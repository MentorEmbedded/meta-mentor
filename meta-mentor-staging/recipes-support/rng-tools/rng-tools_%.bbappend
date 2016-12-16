FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rngd.service"

inherit systemd

SYSTEMD_SERVICE_${PN} = "rngd.service"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/rngd.service ${D}${systemd_unitdir}/system
}
