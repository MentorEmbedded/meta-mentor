FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_initramfs-module-lvm += "lvm2"
RRECOMMENDS_${PN}-base += "initramfs-module-lvm"
