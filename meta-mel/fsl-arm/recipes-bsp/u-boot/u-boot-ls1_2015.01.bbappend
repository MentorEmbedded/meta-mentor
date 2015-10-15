FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Fix crash issues and kernel lockup issues with GCC-4.9.x & Add GCC5 support
SRC_URI += "file://0001-ls102xa-LS1021-ARM-Generic-Timer-CompareValue-Set-64.patch \
	    file://gcc5.patch \
	   "

UBOOT_CONFIG_append = " lpuart"

do_deploy () {
   install -d ${DEPLOYDIR}
   install ${S}/ls1021atwr_nor_config/u-boot.bin ${DEPLOYDIR}/u-boot-nor-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX}
   install ${S}/ls1021atwr_nor_lpuart_config/u-boot.bin ${DEPLOYDIR}/u-boot-lpuart-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX}

   cd ${DEPLOYDIR}
   ln -sf u-boot-nor-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX} u-boot-nor.${UBOOT_SUFFIX}
   ln -sf u-boot-lpuart-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX} u-boot-lpuart.${UBOOT_SUFFIX}
}
