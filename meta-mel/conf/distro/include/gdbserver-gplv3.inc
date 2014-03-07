# Let external-sourcery-toolchain emit a gdbserver package, even if it's GPLv3
# and GPLv3 is in INCOMPATIBLE_LICENSE, to make it available for debugging,
# but don't allow it to be installed into an image in that case unless the
# user explicitly allows it via ALLOW_GPLV3_GDBSERVER.

ALLOW_GPLV3_GDBSERVER ?= ""
INCOMPATIBLE_LICENSE_pn-external-sourcery-toolchain = ""
ROOTFS_POSTPROCESS_COMMAND_append = " check_for_gdbserver;"

python adjust_packagegroup_gdbserver () {
    if not isinstance(e, bb.event.ConfigParsed):
        return
    d = e.data

    if 'GPLv3' in (d.getVar('INCOMPATIBLE_LICENSE', True) or ''):
        if not d.getVar('ALLOW_GPLV3_GDBSERVER', True):
            # Remove installation of gdbserver from codebench-debug
            pkggroup = d.getVar('FEATURE_PACKAGES_codebench-debug', True).split()
            pkggroup.remove('gdbserver')
            d.setVar('FEATURE_PACKAGES_codebench-debug', ' '.join(pkggroup))
}
addhandler adjust_packagegroup_gdbserver

check_for_gdbserver () {
    if echo '${INCOMPATIBLE_LICENSE}' | grep -q 'GPLv3' && \
       [ -z "${ALLOW_GPLV3_GDBSERVER}" ]; then
        gdb_gplv3="$(sed -n '/^PACKAGE NAME: gdbserver$/{ n; n; n; /LICENSE: GPLv3/p }')"
        if [ -n "$gdb_gplv3" ]; then
            bbfatal "Detected GPLv3 gdbserver package in license manifest, aborting. To allow this to be included, define ALLOW_GPLv3_GDBSERVER=1"
        fi
    fi
}
