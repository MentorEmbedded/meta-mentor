# Populate an isolated SSTATE_DIR while still populating the default shared
# sstate directory. This is useful if SSTATE_DIR is shared, so we have access
# to the set of cached binaries which were used in this build.

ISOLATED_SSTATE_DIR ?= "${TMPDIR}/sstate-cache"
ISOLATED_SSTATE_PATHSPEC = "${@SSTATE_PATHSPEC.replace(SSTATE_DIR, ISOLATED_SSTATE_DIR)}"

sstate_write_isolated () {
    if [ -n "${ISOLATED_SSTATE_DIR}" ]; then
        isolated_dest=$(echo ${SSTATE_PKG} | sed 's,^${SSTATE_DIR}/,${ISOLATED_SSTATE_DIR}/,')
        mkdir -p $(dirname $isolated_dest)
        rm -f $isolated_dest $isolated_dest.siginfo
        ln -s ${SSTATE_PKG} $isolated_dest
        ln -s ${SSTATE_PKG}.siginfo $isolated_dest.siginfo
    fi
}

sstate_create_package_append () {
    sstate_write_isolated
}

# Copy existing/fetched archives from SSTATE_DIR to ISOLATED_SSTATE_DIR
sstate_write_isolated_preinst () {
    sstate_write_isolated
}

SSTATEPREINSTFUNCS += "sstate_write_isolated_preinst"

def cleansstate_isolated(d):
    isolated = d.getVar('ISOLATED_SSTATE_DIR', True)
    if isolated:
        for task in (d.getVar('SSTATETASKS', True) or "").split():
                ss = sstate_state_fromvars(d, task[3:])
                sstatepkgfile = d.getVar('ISOLATED_SSTATE_PATHSPEC', True) + "*_" + ss['name'] + ".tgz*"
                oe.path.remove(sstatepkgfile)

python do_cleansstate_append() {
        cleansstate_isolated(d)
}
