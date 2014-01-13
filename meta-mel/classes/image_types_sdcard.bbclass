inherit image_types

IMAGE_BOOTLOADER ?= "u-boot"

# Handle u-boot suffixes
UBOOT_SUFFIX ?= "bin"
UBOOT_PADDING ?= "0"
UBOOT_SUFFIX_SDCARD ?= "${UBOOT_SUFFIX}"

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "boot"

# Boot partition size [in KiB]
BOOT_SPACE ?= "8192"

IMAGE_DEPENDS_sdcard = "virtual/kernel ${IMAGE_BOOTLOADER}"

SDCARD = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.sdcard"
IMAGE_FSTYPE_SDCARD ?= "ext3"
SDCARD_ROOTFS ?= "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.${IMAGE_FSTYPE_SDCARD}"

IMAGE_CMD_sdcard () {
	# Align boot partition and calculate total SD card image size
	BOOT_SPACE_BYTES=$(expr ${BOOT_SPACE} \* 1024)
	BOOT_SPACE_ALIGNED=$(expr $BOOT_SPACE_BYTES + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr $BOOT_SPACE_ALIGNED - $BOOT_SPACE_ALIGNED % ${IMAGE_ROOTFS_ALIGNMENT})
	ROOTFS_SIZE=$(expr $ROOTFS_SIZE \* 1024)
	SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + $BOOT_SPACE_ALIGNED + $ROOTFS_SIZE + ${IMAGE_ROOTFS_ALIGNMENT} + ${IMAGE_ROOTFS_ALIGNMENT})

	# Initialize a sparse file
	dd if=/dev/zero of=${SDCARD} bs=1 count=0 seek=$SDCARD_SIZE
	ls -l ${SDCARD}

	${SDCARD_GENERATION_COMMAND}
}
