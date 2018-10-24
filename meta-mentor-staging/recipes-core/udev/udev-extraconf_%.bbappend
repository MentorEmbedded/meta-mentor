FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI +=  "file://mount_modified.sh \
             ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://systemd-udevd.service', '', d)}"

RDEPENDS_${PN} += "util-linux-blkid"

FILES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}/systemd/system/systemd-udevd.service', '', d)}"

do_install_append() {
	install -m 0755 ${WORKDIR}/mount_modified.sh ${D}${sysconfdir}/udev/scripts/mount.sh
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/systemd/system
		install ${WORKDIR}/systemd-udevd.service ${D}${sysconfdir}/systemd/system/systemd-udevd.service
		sed -i 's|@systemd_unitdir@|${systemd_unitdir}|g' ${D}${sysconfdir}/systemd/system/systemd-udevd.service
	fi
}
