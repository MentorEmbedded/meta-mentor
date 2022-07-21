# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# TODO: add an argument to enable/disable dependency traversal vs just the
# specified recipes
import argparse
import logging
import os
import sys
import tempfile

from collections import defaultdict

import bb.command
import bb.cookerdata
import bb.fetch
import bb.utils

from bblayers.common import LayerPlugin

logger = logging.getLogger('bitbake-layers')


def plugin_init(plugins):
    return MELUtilsPlugin()


def iter_except(func, exception, first=None):
      """Call a function repeatedly until an exception is raised.

      Converts a call-until-exception interface to an iterator interface.
      Like __builtin__.iter(func, sentinel) but uses an exception instead
      of a sentinel to end the loop.

      Examples:
          bsddbiter = iter_except(db.next, bsddb.error, db.first)
          heapiter = iter_except(functools.partial(heappop, h), IndexError)
          dictiter = iter_except(d.popitem, KeyError)
          dequeiter = iter_except(d.popleft, IndexError)
          queueiter = iter_except(q.get_nowait, Queue.Empty)
          setiter = iter_except(s.pop, KeyError)

      """
      try:
          if first is not None:
              yield first()
          while 1:
              yield func()
      except exception:
          pass


class MELUtilsPlugin(LayerPlugin):
    def _get_depgraph(self, targets, task='do_build'):
        depgraph = None

        self.tinfoil.set_event_mask(['bb.event.DepTreeGenerated', 'bb.command.CommandCompleted', 'bb.event.NoProvider', 'bb.command.CommandFailed', 'bb.command.CommandExit'])
        if not self.tinfoil.run_command('generateDepTreeEvent', targets, task):
            logger.critical('Error starting dep tree event command')
            return 1

        for event in iter_except(lambda: self.tinfoil.wait_event(0.25), Exception):
            if event is None:
                continue
            if isinstance(event, bb.command.CommandCompleted):
                break
            elif isinstance(event, bb.command.CommandFailed):
                return None, 'Error running command: %s' % event.error
            elif isinstance(event, bb.command.CommandExit):
                return None, 'Error running command: exited with %s' % event.exitcode
            elif isinstance(event, bb.event.NoProvider):
                if event._reasons:
                    return None, 'Nothing provides %s: %s' % (event._item, event._reasons)
                else:
                    return None, 'Nothing provides %s.' % event._item
            elif isinstance(event, bb.event.DepTreeGenerated):
                depgraph = event._depgraph
                break
            elif isinstance(event, logging.LogRecord):
                logger.handle(event)
            else:
                logger.warning('Unhandled event %s: %s' % (event.__class__.__name__, event))
        return depgraph, None

    def _localpaths_by_layer(self, data, recipe_filename, layer_for_file, mirrortarballs=False):
        def ud_localpaths(u, layer_name, dldir, d):
            if hasattr(u.method, 'process_submodules'):
                def archive_submodule(ud, url, module, modpath, workdir, d):
                    url += ";bareclone=1;nobranch=1"
                    newfetch = bb.fetch2.Fetch([url], d)
                    for subud in newfetch.ud.values():
                        return ud_localpaths(subud, layer_name, dldir, d)

                # If we're using a shallow mirror tarball it needs to be unpacked
                # temporarily so that we can examine the .gitmodules file
                if u.shallow and os.path.exists(u.fullshallow) and u.method.need_update(u, d):
                    import tempfile
                    with tempfile.TemporaryDirectory(dir=dldir) as tmpdir:
                        bb.fetch2.runfetchcmd("tar -xzf %s" % u.fullshallow, d, workdir=tmpdir)
                        u.method.process_submodules(u, tmpdir, archive_submodule, d)
                else:
                    u.method.process_submodules(u, u.clonedir, archive_submodule, d)

            decoded = bb.fetch.decodeurl(u.url)
            if decoded[0] == 'file':
                return

            u.setup_localpath(data)
            localpath = u.localpath

            if mirrortarballs and hasattr(u, 'mirrortarballs'):
                for mt in u.mirrortarballs:
                    mt_abs = os.path.join(dldir, mt)
                    if os.path.exists(mt_abs):
                        localpath = mt_abs
                        break

            items_by_layer[layer_name].add(os.path.normpath(localpath))

        src_uri = data.getVar('SRC_URI').split()
        fetcher = bb.fetch.Fetch(src_uri, data)
        urldata = fetcher.ud
        dldir = data.getVar('DL_DIR')

        items_by_layer = defaultdict(set)
        items_files = data.varhistory.get_variable_items_files('SRC_URI')
        for item, filename in items_files.items():
            ud = urldata[item]
            layer_name = layer_for_file(filename)
            ud_localpaths(ud, layer_name, dldir, data)

        recipe_layer_name = layer_for_file(recipe_filename)
        for extra_item in set(src_uri) - set(items_files.keys()):
            logger.warning('Unable to determine correct layer for `%s`: this item is missing from variable history', extra_item)
            ud = urldata[extra_item]
            ud_localpaths(ud, recipe_layer_name, dldir, data)

        return items_by_layer

    def _collect_fetch_recipes(self, targets, ctask, depgraph):
        tdepends = depgraph['tdepends']
        fetch_recipes = set()
        for target in targets:
            if ':' in target:
                recipe, task = target.split(':', 1)
            else:
                recipe, task = target, ctask

            if not task.startswith('do_'):
                task = 'do_' + task

            if task == 'do_fetch':
                fetch_recipes.add(recipe)

        for task, taskdeps in tdepends.items():
            for dep in taskdeps:
                deprecipe, deptask = dep.rsplit('.', 1)
                if deptask == 'do_fetch':
                    fetch_recipes.add(deprecipe)
        return fetch_recipes

    def _gather_downloads(self, args):
        if args.task is None:
            args.task = self.tinfoil.config_data.getVar('BB_DEFAULT_TASK') or 'build'
        if not args.task.startswith('do_'):
            args.task = 'do_' + args.task

        depgraph, error = self._get_depgraph(args.targets, args.task)
        if not depgraph:
            if error:
                logger.critical('Failed to get the dependency graph: %s' % error)
                return 1
            else:
                logger.critical('Failed to get the dependency graph')
                return 1

        layer_data = depgraph['layer-priorities']

        def layer_for_file(filename):
            for name, pattern, re, priority in layer_data:
                if re.match(filename):
                    return name

        fetch_recipes = self._collect_fetch_recipes(args.targets, args.task, depgraph)

        self.tinfoil.run_command('enableDataTracking')

        items_by_layer = defaultdict(set)
        for recipe in fetch_recipes:
            try:
                fn = depgraph['pn'][recipe]['filename']
            except KeyError:
                mc = self.tinfoil.config_data.getVar('BBMULTICONFIG')
                if not mc:
                    raise Exception("Could not find key '%s' in depgraph and no multiconfigs defined" % recipe)
                for cfg in mc.split():
                    try:
                        nkey = f"mc:{cfg}:{recipe}"
                        fn = depgraph['pn'][nkey]['filename']
                    except KeyError:
                        continue
            if not fn:
                raise Exception("Could not find recipe for '%s' in depgraph" % recipe)

            real_fn, cls, mc = bb.cache.virtualfn2realfn(fn)
            recipe_layer = layer_for_file(real_fn)
            appends = self.tinfoil.get_file_appends(fn)
            data = self.tinfoil.parse_recipe_file(fn, appendlist=appends)

            for layer, items in self._localpaths_by_layer(data, real_fn, lambda f: layer_for_file(f) or recipe_layer, args.mirrortarballs).items():
                items_by_layer[layer] |= items

        # If a given download is used by multiple layers, prefer the lowest
        # priority, i.e. associating it with oe-core vs some random layer
        seen = set()
        layer_priorities = {l: p for l, _, _, p in layer_data}
        for layer in sorted(layer_priorities, key=lambda i: layer_priorities[i]):
            for item in sorted(items_by_layer[layer]):
                if item not in seen:
                    seen.add(item)
                    yield layer, item

    def do_gather_downloads(self, args):
        """Gather up downloads for the specified targets, grouped by layer."""
        for layer, item in self._gather_downloads(args):
            print('%s\t%s' % (layer, item))

    def do_dump_downloads(self, args):
        """Dump downloads by layer into ${TMPDIR}/downloads-by-layer.txt."""
        items = self._gather_downloads(args)
        filename = self.tinfoil.config_data.expand(args.filename)
        omode = 'a' if args.append else 'w'
        with open(filename, omode) as f:
            for layer, item in items:
                f.write('%s\t%s\n' % (layer, item))

    def do_dump_licenses(self, args):
        """Dump licenses of all packages in the depgraph of a target into ${TMPDIR}/pn-buildlist-licenses.txt."""
        if args.task is None:
            args.task = self.tinfoil.config_data.getVar('BB_DEFAULT_TASK') or 'build'
        if not args.task.startswith('do_'):
            args.task = 'do_' + args.task

        filename = self.tinfoil.config_data.expand(args.filename)

        depgraph, error = self._get_depgraph(args.targets, args.task)
        if not depgraph:
            if error:
                logger.critical('Failed to get the dependency graph: %s' % error)
                return 1
            else:
                logger.critical('Failed to get the dependency graph')
                return 1

        fetch_recipes = self._collect_fetch_recipes(args.targets, args.task, depgraph)

        omode = 'a' if args.append else 'w'
        with open(filename, omode) as f:
            for recipe in fetch_recipes:
                try:
                    fn = depgraph['pn'][recipe]['filename']
                except KeyError:
                    mc = self.tinfoil.config_data.getVar('BBMULTICONFIG')
                    if not mc:
                        raise Exception("Could not find key '%s' in depgraph and no multiconfigs defined" % recipe)
                    for cfg in mc.split():
                        try:
                            nkey = f"mc:{cfg}:{recipe}"
                            fn = depgraph['pn'][nkey]['filename']
                        except KeyError:
                            continue
                if not fn:
                    raise Exception("Could not find recipe for '%s' in depgraph" % recipe)

                real_fn, cls, mc = bb.cache.virtualfn2realfn(fn)
                appends = self.tinfoil.get_file_appends(fn)
                data = self.tinfoil.parse_recipe_file(fn, appendlist=appends)

                pn = data.getVar('PN')
                pv = data.getVar('PV')
                lc = data.getVar('LICENSE')

                if not args.sourceinfo:
                    f.write('%s,%s,%s\n' % (pn, pv, lc))
                else:
                    # unset su, otherwise we get previous value if there is no current
                    su = ''
                    for url in data.getVar('SRC_URI').split():
                        scheme, host, path, user, passwd, param = bb.fetch.decodeurl(url)
                        if scheme != 'file':
                            su = bb.fetch.encodeurl((scheme, host, path, '', '', ''))
                    hp = data.getVar('HOMEPAGE')

                    f.write('%s,%s,%s,%s,%s\n' % (pn, pv, lc, su, hp))

        # remove any duplicates added due to append flag
        uniqlines = set(open(filename).readlines())
        with open(filename, 'w') as f:
            f.writelines(uniqlines)

    def register_commands(self, sp):
        common = argparse.ArgumentParser(add_help=False)
        common.add_argument('--mirrortarballs', '-m', help='show existing mirror tarball paths rather than git clone paths', action='store_true')
        common.add_argument('--task', '-c', help='specify the task to use when not expicitly specified for a target (default: BB_DEFAULT_TASK or "build")')
        common.add_argument('targets', nargs='+')

        gather = self.add_command(sp, 'gather-downloads', self.do_gather_downloads, parents=[common], parserecipes=True)
        dump = self.add_command(sp, 'dump-downloads', self.do_dump_downloads, parents=[common], parserecipes=True)
        dump.add_argument('--append', '-a', help='append to output filename', action='store_true')
        dump.add_argument('--filename', '-f', help='filename to dump to', default='${TMPDIR}/downloads-by-layer.txt')
        license = self.add_command(sp, 'dump-licenses', self.do_dump_licenses, parents=[common], parserecipes=True)
        license.add_argument('--filename', '-f', help='filename to dump to', default='${TMPDIR}/pn-buildlist-licenses.txt')
        license.add_argument('--append', '-a', help='append to output filename', action='store_true')
        license.add_argument('--sourceinfo', '-s', help='additionally dump SRC_URI and HOMEPAGE variables too', action='store_true')
