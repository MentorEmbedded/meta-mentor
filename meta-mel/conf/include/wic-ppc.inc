# Wic bits common to all e500v2 boards

KERNEL_IMAGETYPE ?= "uImage"

IMAGE_BOOT_FILES ?= "${KERNEL_IMAGETYPE} ${UBOOT_BINARY} \
                ${@' '.join('${KERNEL_IMAGETYPE}-%s' % devicetree for devicetree in KERNEL_DEVICETREE.split())}"

# WIC image type support
WKS_FILE ?= "sdimage-bootpart-4g.wks"

# u-boot is needed for our IMAGE_BOOT_FILES
IMAGE_DEPENDS_wic_append = " virtual/bootloader"

# Bits common to All MEL BSPs
require conf/include/wic-common.inc
