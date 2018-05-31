FILESEXTRAPATHS_prepend := "${THISDIR}/rng-tools:"
SRC_URI += "file://10-sysinit.conf"

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d "${D}${systemd_unitdir}/system/rngd.service.d"
        install -m 0644 ${WORKDIR}/10-sysinit.conf "${D}${systemd_unitdir}/system/rngd.service.d/"
    fi
}

FILES_${PN} +=  "${systemd_unitdir}/system/*.service.d"
INITSCRIPT_PARAMS = "start 03 2 3 4 5 . stop 30 0 6 1 ."
