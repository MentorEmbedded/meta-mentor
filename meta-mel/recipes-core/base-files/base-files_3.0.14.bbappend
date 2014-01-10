PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}:"

dirs755 += "${sysconfdir}/alternatives \
            ${localstatedir}/lib/alternatives \
            "
