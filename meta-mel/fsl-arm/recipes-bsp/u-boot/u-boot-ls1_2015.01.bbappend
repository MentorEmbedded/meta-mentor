FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Fix crash issues and kernel lockup issues with GCC-4.9.x & Add GCC5 support
SRC_URI += "file://0001-ls102xa-LS1021-ARM-Generic-Timer-CompareValue-Set-64.patch \
	    file://gcc5.patch \
	   "

UBOOT_CONFIG_append = " lpuart"

do_deploy () {
   install -m 0755 ${S}/ls1021atwr_nor_config/u-boot.bin  ${DEPLOY_DIR_IMAGE}/u-boot-nor.bin
   install -m 0755 ${S}/ls1021atwr_nor_lpuart_config/u-boot.bin ${DEPLOY_DIR_IMAGE}/u-boot-lpuart.bin
}
