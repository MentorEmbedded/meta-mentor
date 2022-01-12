# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: GPL-2.0
# ---------------------------------------------------------------------------------------------------------------------

# Recipe creation tool - kernel plugin
#
# TODO: figure out how to get all the files added to a single SRC_URI +=
# rather than multiple, while still getting the nice multi-line value
# TODO: add support to oe.recipeutils to let us add include/require lines via
# 'extralines', which is not currently supported. We could then
# pull in linux-dtb.inc automatically if appropriate.
#
# These sub-commands are thin wrappers around appendsrcfile(s) coupled
# with additional configuration variables.
#
# Examples:
#
#     $ recipetool kernel_set_defconfig meta-mylayer /path/to/defconfig
#     $ recipetool kernel_add_fragments meta-mylayer one.cfg two.cfg
#     $ recipetool kernel_set_configs meta-mylayer CONFIG_LOCALVERSION_AUTO=n CONFIG_LOCALVERSION=-test
#     $ recipetool kernel_add_dts meta-mylayer *.dts
#
#
# Copyright 2022 Siemens
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

import argparse
import logging
import os
import re


logger = logging.getLogger('recipetool')
tinfoil = None


def plugin_init(pluginlist):
    # Don't need to do anything here right now, but plugins must have this function defined
    pass


def tinfoil_init(instance):
    global tinfoil
    tinfoil = instance


def _get_recipe_file(cooker, pn):
    import oe.recipeutils
    best = cooker.findBestProvider(pn)
    recipefile = best[3]
    if not recipefile:
        skipreasons = oe.recipeutils.get_unavailable_reasons(cooker, pn)
        if skipreasons:
            logger.error('\n'.join(skipreasons))
        else:
            logger.error("Unable to find any recipe file matching %s" % pn)
    return recipefile


def _parse_recipe(pn, tinfoil):
    recipefile = _get_recipe_file(tinfoil.cooker, pn)
    if not recipefile:
        # Error already logged
        return None
    return tinfoil.parse_recipe(pn)


def append_srcfiles(destlayer, rd, files, use_workdir=False, use_machine=False, wildcard_version=False, extralines=None):
    import recipetool.append

    pn = rd.getVar('PN', True)
    if use_machine:
        machine = rd.getVar('MACHINE', True)
    else:
        machine = None
    appendargs = argparse.Namespace(destlayer=destlayer, recipe=pn, use_workdir=use_workdir, wildcard_version=wildcard_version, machine=machine)
    recipetool.append.appendsrc(appendargs, files, rd, extralines)


def kernel_set_defconfig(args):
    rd = _parse_recipe(args.recipe, tinfoil)
    if not rd:
        return 1

    import bb.data
    if not bb.data.inherits_class('kernel-yocto', rd):
        extralines = []
        for configvar in ['KERNEL_DEFCONFIG', 'DEFCONFIG']:
            if rd.getVar(configvar, True):
                extralines.append('{0} = ${{WORKDIR}}/defconfig'.format(configvar))
    else:
        extralines = None

    return append_srcfiles(args.destlayer, rd, {args.defconfig: 'defconfig'}, use_workdir=True, use_machine=True, extralines=extralines)


def kernel_add_dts(args):
    import oe.recipeutils

    rd = _parse_recipe(args.recipe, tinfoil)
    if not rd:
        return 1

    dtbs = (os.path.basename(dts.replace('dts', 'dtb')) for dts in args.dts_files)
    extralines = ['KERNEL_DEVICETREE += {0}'.format(' '.join(dtbs))]
    files = dict((dts, os.path.join('arch/${{ARCH}}/boot/dts/{0}'.format(os.path.basename(dts)))) for dts in args.dts_files)
    ret = append_srcfiles(args.destlayer, rd, files, use_workdir=False, use_machine=True, extralines=extralines)

    packages = rd.getVar('PACKAGES', True).split()
    if 'kernel-devicetree' not in packages:
        appendpath, _ = oe.recipeutils.get_bbappend_path(rd, args.destlayer, wildcardver=False)
        with open(appendpath, 'a') as f:
            f.write('require recipes-kernel/linux/linux-dtb.inc')
    return ret


def kernel_add_fragments(args):
    rd = _parse_recipe(args.recipe, tinfoil)
    if not rd:
        return 1

    return _kernel_add_fragments(args.destlayer, rd, args.fragments)


def _kernel_add_fragments(destlayer, rd, fragments, files=None, extralines=None):
    depends = rd.getVar('DEPENDS', True).split()
    md_depends = (rd.getVarFlag('do_kernel_metadata', 'depends', True) or '').split()
    depends.extend(dep.split(':', 1)[0] for dep in md_depends)

    if extralines is None:
        extralines = []

    if 'DELTA_KERNEL_DEFCONFIG' in rd:
        # linux-qoriq handles fragments itself
        extralines.append('DELTA_KERNEL_DEFCONFIG += {0}'.format(' '.join('${WORKDIR}/%s' % os.path.basename(f) for f in fragments)))
    else:
        if 'kern-tools-native' not in depends:
            logger.warn("kern-tools-native not found in the kernel's dependencies. This likely means that this kernel recipe ({0}) does not support configuration fragments.".format(rd.getVar('PN', True)))

    if files is None:
        files = dict((f, os.path.basename(f)) for f in fragments)
    return append_srcfiles(destlayer, rd, files, use_workdir=True, use_machine=True, extralines=extralines)


def get_next_fragment_name(src_uri):
    fragpat = re.compile('file://recipetool([0-9]+)\.cfg$')
    matches = list(filter(None, [re.match(fragpat, u) for u in src_uri]))
    if matches:
        fragnums = sorted((int(m.group(1)) for m in matches), reverse=True)
        num = fragnums[0] + 1
    else:
        num = 0
    return 'recipetool%d' % num


def kernel_set_configs(args):
    rd = _parse_recipe(args.recipe, tinfoil)
    if not rd:
        return 1

    if not args.name:
        src_uri = rd.getVar('SRC_URI', True).split()
        args.name = get_next_fragment_name(src_uri)

    import tempfile
    f = tempfile.NamedTemporaryFile(mode='w', delete=False)
    try:
        for cfgline in args.config_lines:
            f.write(cfgline + '\n')
    finally:
        f.close()

    fragfn = '{0}.cfg'.format(args.name)
    try:
        return _kernel_add_fragments(args.destlayer, rd, fragfn, files={f.name: fragfn})
    finally:
        os.unlink(f.name)


def layer(layerpath):
    if not os.path.exists(os.path.join(layerpath, 'conf', 'layer.conf')):
        raise argparse.ArgumentTypeError('{0!r} must be a path to a valid layer'.format(layerpath))
    return layerpath


def existing_path(filepath):
    if not os.path.exists(filepath):
        raise argparse.ArgumentTypeError('{0!r} must be an existing path'.format(filepath))
    return filepath


def register_command(subparsers):
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument('-r', '--recipe', help='Specify the kernel recipe to operate against (default: virtual/kernel)', default='virtual/kernel')

    parser = subparsers.add_parser('kernel_set_defconfig', help='Override the defconfig used for the kernel.', parents=[common])
    parser.add_argument('destlayer', metavar='DESTLAYER', help='Base directory of the destination layer to write the bbappend to', type=layer)
    parser.add_argument('defconfig', metavar='DEFCONFIG', help='File path to the defconfig to be used', type=existing_path)
    parser.set_defaults(func=kernel_set_defconfig, parserecipes=True)

    parser = subparsers.add_parser('kernel_add_dts', help='Add/replace device tree files in the kernel.', parents=[common])
    parser.add_argument('destlayer', metavar='DESTLAYER', help='Base directory of the destination layer to write the bbappend to', type=layer)
    parser.add_argument('dts_files', metavar='DTS_FILE', nargs='+', help='File path to a .dts', type=existing_path)
    parser.set_defaults(func=kernel_add_dts, parserecipes=True)

    parser = subparsers.add_parser('kernel_add_fragments', help='Add configuration fragments to the kernel.', parents=[common])
    parser.add_argument('destlayer', metavar='DESTLAYER', help='Base directory of the destination layer to write the bbappend to', type=layer)
    parser.add_argument('fragments', metavar='FRAGMENT', nargs='+', help='File path to a configuration fragment (.cfg)', type=existing_path)
    parser.set_defaults(func=kernel_add_fragments, parserecipes=True)

    parser = subparsers.add_parser('kernel_set_configs', help='Set kernel configuration parameters. Generates and includes kernel config fragments for you.', parents=[common])
    parser.add_argument('-n', '--name', metavar='NAME', help='Name of the fragment to be generated (without .cfg)')
    parser.add_argument('destlayer', metavar='DESTLAYER', help='Base directory of the destination layer to write the bbappend to', type=layer)
    parser.add_argument('config_lines', metavar='CONFIG_LINE', nargs='+', help='Kernel configuration line (e.g. CONFIG_FOO=y)')
    parser.set_defaults(func=kernel_set_configs, parserecipes=True)
