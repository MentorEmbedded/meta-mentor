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

    def _localpaths_by_layer(self, data, layer_for_file, mirrortarballs=False):
        src_uri = data.getVar('SRC_URI').split()
        fetcher = bb.fetch.Fetch(src_uri, data)
        urldata = fetcher.ud

        items_by_layer = defaultdict(set)
        items_files = data.varhistory.get_variable_items_files('SRC_URI', data)
        for item, filename in items_files.items():
            ud = urldata[item]
            decoded = bb.fetch.decodeurl(item)
            if decoded[0] == 'file':
                continue

            ud.setup_localpath(data)
            localpath = ud.localpath

            if mirrortarballs and hasattr(ud, 'mirrortarballs'):
                dldir = data.getVar('DL_DIR')
                for mt in ud.mirrortarballs:
                    mt_abs = os.path.join(dldir, mt)
                    if os.path.exists(mt_abs):
                        localpath = mt_abs
                        break

            layer_name = layer_for_file(filename)
            if not layer_name:
                # Possibly it referred to a .inc or similar, but the layer
                # inclusion pattern was too specific to pick it up, in
                # that case just use the layer for the recipe itself
                layer_name = recipe_layer
            items_by_layer[layer_name].add(os.path.normpath(localpath))

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
            fn = depgraph['pn'][recipe]['filename']
            real_fn, cls, mc = bb.cache.virtualfn2realfn(fn)
            recipe_layer = layer_for_file(real_fn)
            appends = self.tinfoil.get_file_appends(fn)
            data = self.tinfoil.parse_recipe_file(fn, appendlist=appends)

            for layer, items in self._localpaths_by_layer(data, lambda f: layer_for_file(f) or recipe_layer, args.mirrortarballs).items():
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

        with open(filename, 'w') as f:
            for recipe in fetch_recipes:
                fn = depgraph['pn'][recipe]['filename']
                real_fn, cls, mc = bb.cache.virtualfn2realfn(fn)
                appends = self.tinfoil.get_file_appends(fn)
                data = self.tinfoil.parse_recipe_file(fn, appendlist=appends)

                pn = data.getVar('PN')
                pv = data.getVar('PV')
                lc = data.getVar('LICENSE')
                # For SRC_URI we need to drop the local sources i.e. file:// entries
                # then for further filtering we pick up only the initial part of the archive/git src i.e. dropping out
                # bitbake specifics like protocol, branch, name etc.
                su = " ".join([x.split(';')[0] for x in data.getVar('SRC_URI').split() if not x.startswith('file://')])
                hp = data.getVar('HOMEPAGE')

                f.write('%s,%s,%s,%s,%s\n' % (pn, pv, lc, su, hp))

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
