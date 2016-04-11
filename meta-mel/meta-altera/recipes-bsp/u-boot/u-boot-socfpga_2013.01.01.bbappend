FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += "mkpimage-native u-boot-mkimage-native"

SRC_URI_append = " file://u-boot.txt"

UBOOT_TAG = "d141e218f3195e305c1521a0d67c81b7cb504b71"
UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "u-boot"

do_compile_append () {
	oe_runmake HOSTCC='${CC}' HOSTLDFLAGS='${LDFLAGS}' HOSTSTRIP='true' env
	mkpimage -o ${B}/spl/u-boot-spl-mkpimage.bin ${B}/spl/u-boot-spl.bin
	mkimage -A arm -T script -C none -n "Boot Image" -d ${WORKDIR}/u-boot.txt ${WORKDIR}/u-boot.scr
}

do_deploy_append () {
	install ${B}/spl/u-boot-spl-mkpimage.bin ${DEPLOYDIR}/u-boot-spl-mkpimage.bin
	install ${WORKDIR}/u-boot.scr ${DEPLOYDIR}/

	# Remove additional files that are un-wanted
	rm -f ${DEPLOYDIR}/u-boot-spl-${MACHINE}.bin \
	      ${DEPLOYDIR}/u-boot-spl-${MACHINE}-${PV}-${PR}.bin
}
