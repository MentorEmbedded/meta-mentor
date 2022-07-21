# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# Populate an isolated SSTATE_DIR while still populating the default shared
# sstate directory. This is useful if SSTATE_DIR is shared, so we have access
# to the set of cached binaries which were used in this build.

ISOLATED_SSTATE_DIR ?= "${TMPDIR}/sstate-cache"
ISOLATED_SSTATE_PATHSPEC = "${@SSTATE_PATHSPEC.replace(SSTATE_DIR + '/', ISOLATED_SSTATE_DIR + '/')}"

sstate_write_isolated () {
    if [ -n "${ISOLATED_SSTATE_DIR}" ] && \
       [ "${ISOLATED_SSTATE_DIR}" != "${SSTATE_DIR}" ]; then
        isolated_dest=$(echo ${SSTATE_PKG} | sed 's,^${SSTATE_DIR}/,${ISOLATED_SSTATE_DIR}/,')
        mkdir -p $(dirname $isolated_dest)
        rm -f $isolated_dest $isolated_dest.siginfo
        ln -s ${SSTATE_PKG} $isolated_dest
        ln -s ${SSTATE_PKG}.siginfo $isolated_dest.siginfo
    fi
}

sstate_create_package:append () {
    sstate_write_isolated
}
# Work around missing vardep bug in bitbake
sstate_create_package[vardeps] += "sstate_write_isolated"

# Copy existing/fetched archives from SSTATE_DIR to ISOLATED_SSTATE_DIR
sstate_write_isolated_preinst () {
    sstate_write_isolated
}

SSTATEPREINSTFUNCS:append = " sstate_write_isolated_preinst"

def cleansstate_isolated(d):
    if d.getVar('ISOLATED_SSTATE_DIR', True) != d.getVar('SSTATE_DIR', True):
        l = d.createCopy()
        l.setVar('SSTATE_PATHSPEC', d.getVar('ISOLATED_SSTATE_PATHSPEC', True))
        sstate_clean_cachefiles(l)

python do_cleansstate:append() {
        cleansstate_isolated(d)
}

# Sadly, there's no way to guarantee event handler execution order, so we need
# to duplicate the bits to dump the siginfo to SSTATE_DIR.
addhandler isolated_sstate_eventhandler
isolated_sstate_eventhandler[eventmask] = "bb.build.TaskSucceeded"
python isolated_sstate_eventhandler() {
    sstate_dir = d.getVar('SSTATE_DIR', True)
    isolated_sstate_dir = d.getVar('ISOLATED_SSTATE_DIR', True)
    if sstate_dir == isolated_sstate_dir:
        return

    # When we write an sstate package we rewrite the SSTATE_PKG
    spkg = d.getVar('SSTATE_PKG', True)
    if not spkg.endswith(".tgz"):
        taskname = d.getVar("BB_RUNTASK", True)[3:]
        spec = d.getVar('SSTATE_PKGSPEC', True)
        swspec = d.getVar('SSTATE_SWSPEC', True)
        if taskname in ["fetch", "unpack", "patch", "populate_lic"] and swspec:
            d.setVar("SSTATE_PKGSPEC", "${SSTATE_SWSPEC}")
            d.setVar("SSTATE_EXTRAPATH", "")
        sstatepkg = d.getVar('SSTATE_PKG', True)
        fn = sstatepkg + '_' + taskname + '.tgz.siginfo'
        if not os.path.exists(fn):
            bb.utils.mkdirhier(os.path.dirname(fn))
            bb.siggen.dump_this_task(fn, d)

        isolated_fn = fn.replace(sstate_dir + '/', isolated_sstate_dir + '/')
        if not os.path.exists(isolated_fn):
            bb.utils.mkdirhier(os.path.dirname(isolated_fn))
            os.symlink(fn, isolated_fn)
}
