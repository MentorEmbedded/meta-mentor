FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


SRC_URI_append = " file://automount.rules \
			file://mount.sh \
"

do_install_prepend () {
	install -d ${D}${sysconfdir}/udev/rules.d
	install -m 0644 ${WORKDIR}/automount.rules ${D}${sysconfdir}/udev/rules.d

	install -d ${D}${sysconfdir}/udev/scripts/
	install -m 0755 ${WORKDIR}/mount.sh ${D}${sysconfdir}/udev/scripts/mount.sh
}
