UBOOT_MAKE_TARGET += "u-boot-with-spl-dtb.sfp"
SPL_BINARY = "u-boot-with-spl-dtb.sfp"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:" 
SRC_URI_append = " file://u-boot.txt"
DEPENDS += " u-boot-mkimage-native"
UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "u-boot"
do_compile_append() {
	mkimage -A arm -T script -C none -n "Boot Image" -d ${WORKDIR}/u-boot.txt ${WORKDIR}/u-boot.scr
}

