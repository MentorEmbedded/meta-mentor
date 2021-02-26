FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://lvm2-mel.service"

PACKAGES += "${PN}-mel"
SYSTEMD_PACKAGES += "${PN}-mel"
SYSTEMD_SERVICE_${PN}-mel = "lvm2-mel.service"
SYSTEMD_AUTO_ENABLE_${PN}-mel = "enable"
RDEPENDS_${PN} += "${PN}-mel"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/${SYSTEMD_SERVICE_${PN}-mel} ${D}${systemd_system_unitdir}/
    fi
}
