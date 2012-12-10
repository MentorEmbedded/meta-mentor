inherit sstate-postprocess

# Populate an isolated SSTATE_DIR while still populating the default shared
# sstate directory. This is useful if SSTATE_DIR is shared, so we have access
# to the set of cached binaries which were used in this build.

ISOLATED_SSTATE_DIR ?= "${TMPDIR}/sstate-cache"
ISOLATED_SSTATE_PATHSPEC = "${@SSTATE_PATHSPEC.replace(SSTATE_DIR, ISOLATED_SSTATE_DIR)}"

# Copy newly created archives to the isolated sstate dir
sstate_write_isolated () {
    if [ -n "${ISOLATED_SSTATE_DIR}" ]; then
        sstate_pkg="$1"
        isolated_dest=$(echo $sstate_pkg | sed 's,^${SSTATE_DIR}/,${ISOLATED_SSTATE_DIR}/,')
        mkdir -p $(dirname $isolated_dest)
        rm -f $isolated_dest
        ln -s $sstate_pkg $isolated_dest
    fi
}

SSTATE_POSTPROCESS_FUNCS += "sstate_write_isolated"

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
