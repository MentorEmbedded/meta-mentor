FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
RRECOMMENDS_${PN} += "os-release"

SRC_URI += "file://01-create-run-lock.conf"

do_install_append() {
	install -m 0644 ${WORKDIR}/01-create-run-lock.conf ${D}${sysconfdir}/tmpfiles.d/
}
