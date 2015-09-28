#This file contains the WIC bits that are common to all e500v2 boards

KERNEL_IMAGETYPE ?= "uImage"

IMAGE_BOOT_FILES ?= "${KERNEL_IMAGETYPE} ${UBOOT_BINARY} \
                ${@' '.join('${KERNEL_IMAGETYPE}-%s' % devicetree for devicetree in KERNEL_DEVICETREE.split())}"

# WIC image type support
IMAGE_FSTYPES += "wic.bz2"
WKS_FILE ?= "${MACHINE}.wks"

# u-boot is needed for our IMAGE_BOOT_FILES
IMAGE_DEPENDS_wic_append = " virtual/bootloader"

# dosfstools is needed to create the boot partition, mtools to copy to it
IMAGE_DEPENDS_wic_append = " dosfstools-native mtools-native"
