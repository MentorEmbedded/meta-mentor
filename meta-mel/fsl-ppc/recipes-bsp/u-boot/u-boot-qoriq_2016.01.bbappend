UBOOT_LOCALVERSION = "+${DISTRO_NAME}-${@d.getVar('SDK_VERSION', True).partition('+')[0]}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://p2020rdb-pca-u-boot-nand-fix.patch" 
