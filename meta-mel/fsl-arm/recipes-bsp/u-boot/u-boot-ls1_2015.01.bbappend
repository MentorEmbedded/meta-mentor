FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Fix crash issues and kernel lockup issues with GCC-4.9.x
SRC_URI += "file://0001-ls102xa-LS1021-ARM-Generic-Timer-CompareValue-Set-64.patch"

UBOOT_CONFIG_append = " sdcard lpuart"

do_install_append () {
   #override wrong sd-card u-boot for sdcard
   cp ${S}/ls1021atwr_sdcard_config/u-boot.bin ${WORKDIR}/deploy-u-boot-ls1/u-boot-sdcard-2015.01-r0.bin
}
