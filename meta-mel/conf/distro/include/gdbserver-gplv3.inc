# If ALLOW_GPLV3_GDBSERVER is enabled, gdbserver-external will become
# buildable even when GPLv3 is in INCOMPATIBLE_LICENSE, to make it available
# for debugging.
#
# FIXME: obey the gdb version from the external toolchain, if possible

ALLOW_GPLV3_GDBSERVER ?= ""

python adjust_packagegroup_gdbserver () {
    if 'GPLv3' in (d.getVar('INCOMPATIBLE_LICENSE', True) or ''):
        if not d.getVar('ALLOW_GPLV3_GDBSERVER', True):
            # Remove installation of gdbserver from codebench-debug
            pkggroup = d.getVar('FEATURE_PACKAGES_codebench-debug', True).split()
            pkggroup.remove('gdbserver')
            d.setVar('FEATURE_PACKAGES_codebench-debug', ' '.join(pkggroup))
        else:
            # Allow gdbserver-external to build despite its license
            d.setVar('INCOMPATIBLE_LICENSE_pn-gdbserver-external', '')
}
adjust_packagegroup_gdbserver[eventmask] = "bb.event.ConfigParsed"
addhandler adjust_packagegroup_gdbserver
