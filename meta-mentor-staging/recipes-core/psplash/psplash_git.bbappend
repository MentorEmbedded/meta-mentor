FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://psplash-quit.service \
	file://psplash-start.service \
	"
inherit systemd
SYSTEMD_SERVICE_${PN} = "psplash-start.service psplash-quit.service"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/psplash-quit.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/psplash-start.service ${D}${systemd_unitdir}/system
}
