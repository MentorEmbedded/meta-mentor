# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://lvm2-mel.service"

PACKAGES += "${PN}-mel"
SYSTEMD_PACKAGES += "${PN}-mel"
SYSTEMD_SERVICE:${PN}-mel = "lvm2-mel.service"
SYSTEMD_AUTO_ENABLE:${PN}-mel = "enable"
RDEPENDS:${PN} += "${PN}-mel"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/${SYSTEMD_SERVICE:${PN}-mel} ${D}${systemd_system_unitdir}/
    fi
}
