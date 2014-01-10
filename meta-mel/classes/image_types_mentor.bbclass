inherit image_types_sdcard

# 63 sectors, 512 bytes per sector
IMAGE_ROOTFS_ALIGNMENT_pandaboard = "32256"
SDCARD_GENERATION_COMMAND_pandaboard = "generate_pandaboard_sdcard"
IMAGE_DEPENDS_sdcard += "util-linux-native dosfstools-native mtools-native"

generate_pandaboard_sdcard () {
        total_cyls=$(expr $SDCARD_SIZE / 512 / 63 / 255 + 2)
        boot_cyls=$(expr $BOOT_SPACE_ALIGNED / 512 / 63 / 255 + 1)
        root_cyls=$(expr $ROOTFS_SIZE / 512 / 63 / 255 + 1)
        {
            echo ,$boot_cyls,0C,*
            echo ,$root_cyls,,-
        } | sfdisk -C $total_cyls -S 63 -H 255 -D ${SDCARD}

        boot_line="$(sfdisk -uS -l ${SDCARD} | grep -w ${SDCARD}1)"
        boot_start=$(echo "$boot_line"|awk '{print $3}')
        boot_sectors=$(echo "$boot_line"|awk '{print $5}')
	boot_blocks=$(expr $boot_sectors / 2)

	# Create boot partition image
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $boot_blocks

        export MTOOLS_SKIP_CHECK=1
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/MLO-${MACHINE} ::/MLO
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.img ::/u-boot.img
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/uImage-${MACHINE}.bin ::/uImage

        root_line="$(sfdisk -uS -l ${SDCARD} | grep -w ${SDCARD}2)"
        root_start=$(echo "$root_line"|awk '{print $2}')
        root_sectors=$(echo "$root_line"|awk '{print $4}')
        root_bytes=$(expr $root_sectors \* 512)
        if [ $root_bytes -lt $ROOTFS_SIZE ]; then
            bbfatal "Insufficient room in rootfs partition ($root_bytes) for filesystem ($ROOTFS_SIZE)"
        fi

        IMAGE_CMD_${IMAGE_FSTYPE_SDCARD}

	# Burn Partition
	# dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc seek=1 bs=${IMAGE_ROOTFS_ALIGNMENT} && sync && sync
	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc seek=$boot_start && sync && sync
	# dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc seek=1 bs=$(expr $BOOT_SPACE_ALIGNED + ${IMAGE_ROOTFS_ALIGNMENT}) && sync && sync
	dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc seek=$root_start && sync && sync
}
