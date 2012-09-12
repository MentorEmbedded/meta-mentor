PRINC := "${@int(PRINC) + 1}"
RDEPENDS_${PN} = "\
    distcc-config \
    ${@base_contains('DISTRO_FEATURES', 'x11', 'oprofileui-server', '', d)} \
    nfs-export-root \
    bash \
"
