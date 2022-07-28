# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/${PN}:"
SRC_URI:append:feature-mentor-staging = " file://0001-udev-extraconf-mount.sh-add-LABELs-to-mountpoints.patch \
             ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://systemd-udevd.service', '', d)} \
             file://0002-udev-extraconf-mount.sh-save-mount-name-in-our-tmp-f.patch \
             file://0003-udev-extraconf-mount.sh-only-mount-devices-on-hotplu.patch \
             file://0001-udev-extraconf-mount.sh-ignore-lvm-in-automount.patch \
             file://09-dm_hack.rules"

RDEPENDS:${PN}:append:feature-mentor-staging = " util-linux-blkid"

FILES:${PN}:append:feature-mentor-staging = " ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}/systemd/system/systemd-udevd.service', '', d)}"

do_install:append:feature-mentor-staging () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/systemd/system
		install ${WORKDIR}/systemd-udevd.service ${D}${sysconfdir}/systemd/system/systemd-udevd.service
		sed -i 's|@systemd_unitdir@|${systemd_unitdir}|g' ${D}${sysconfdir}/systemd/system/systemd-udevd.service
	fi
	install -m 0644 ${WORKDIR}/09-dm_hack.rules ${D}${sysconfdir}/udev/rules.d/
}
