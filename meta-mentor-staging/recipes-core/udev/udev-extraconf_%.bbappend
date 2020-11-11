FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI +=  "file://0001-udev-extraconf-mount.sh-add-LABELs-to-mountpoints.patch \
             ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://systemd-udevd.service', '', d)} \
             file://0001-udev-extraconf-mount.sh-define-mount-prefix-using-a-.patch \
             file://0002-udev-extraconf-mount.sh-save-mount-name-in-our-tmp-f.patch \
             file://0003-udev-extraconf-mount.sh-only-mount-devices-on-hotplu.patch \
             file://0001-udev-extraconf-mount.sh-ignore-lvm-in-automount.patch"

RDEPENDS_${PN} += "util-linux-blkid"

FILES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}/systemd/system/systemd-udevd.service', '', d)}"

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/systemd/system
		install ${WORKDIR}/systemd-udevd.service ${D}${sysconfdir}/systemd/system/systemd-udevd.service
		sed -i 's|@systemd_unitdir@|${systemd_unitdir}|g' ${D}${sysconfdir}/systemd/system/systemd-udevd.service
	fi
}
