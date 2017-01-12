FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI +=  "file://mount_modified.sh"

RDEPENDS_${PN} += "util-linux-blkid"

do_install_append() {
	install -m 0755 ${WORKDIR}/mount_modified.sh ${D}${sysconfdir}/udev/scripts/mount.sh
}
