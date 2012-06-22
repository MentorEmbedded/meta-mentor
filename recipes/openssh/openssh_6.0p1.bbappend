PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"
PARALLEL_MAKEINST = ""

DISTRO_TYPE ?= "${@base_contains("IMAGE_FEATURES", "debug-tweaks", "debug", "",d)}"

do_patch[postfuncs] += "do_debug_sed"
do_debug_sed() {
    if [ "${DISTRO_TYPE}" = "debug" ]; then
        sed -i -e 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords yes/' \
               -e 's/^#PermitRootLogin.*/PermitRootLogin yes/' ${WORKDIR}/sshd_config
    fi
}
