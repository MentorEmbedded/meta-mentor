# Use an isolated per-build SSTATE_DIR while still populating a shared sstate
# directory for use across multiple builds.

SHARED_SSTATE_DIR := "${SSTATE_DIR}"
SHARED_SSTATE_PATHSPEC = "${@SSTATE_PATHSPEC.replace(SSTATE_DIR, SHARED_SSTATE_DIR)}"
SSTATE_DIR = "${TMPDIR}/sstate-cache"
SSTATE_MIRRORS += "file://.* file://${SHARED_SSTATE_DIR}/PATH \n "

sstate_create_package_append () {
    if [ "${SSTATE_DIR}" != "${SHARED_SSTATE_DIR}" ]; then
        shared_pkg=$(echo ${SSTATE_PKG} | sed 's,^${SSTATE_DIR}/,${SHARED_SSTATE_DIR}/,')
        mkdir -p $(dirname $shared_pkg)
        mv ${SSTATE_PKG} $shared_pkg
        ln -sf $shared_pkg ${SSTATE_PKG}
    fi
}

python do_cleansstate_append() {
        if d.getVar('SSTATE_DIR', True) == d.getVar('SHARED_SSTATE_DIR', True):
            return

        for task in (d.getVar('SSTATETASKS', True) or "").split():
                ss = sstate_state_fromvars(d, task[3:])
                sstatepkgfile = d.getVar('SHARED_SSTATE_PATHSPEC', True) + "*_" + ss['name'] + ".tgz*"
                bb.note("Removing %s" % sstatepkgfile)
                oe.path.remove(sstatepkgfile)
}
