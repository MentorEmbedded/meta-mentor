FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rngd.service"

inherit systemd

SYSTEMD_SERVICE_${PN} = "rngd.service"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/rngd.service ${D}${systemd_unitdir}/system
}

INITSCRIPT_PARAMS = "start 03 2 3 4 5 . stop 30 0 6 1 ."
