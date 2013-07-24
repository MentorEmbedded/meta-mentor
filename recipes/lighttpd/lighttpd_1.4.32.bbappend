FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://lighttpd.service"

inherit systemd

SYSTEMD_SERVICE_${PN} = "lighttpd.service"

do_install_append() {
    if ${@base_contains('systemd$', DISTRO_FEATURES, 'true', 'false', d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/lighttpd.service ${D}${systemd_unitdir}/system
    fi
}
