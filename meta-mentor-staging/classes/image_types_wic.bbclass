IMAGE_WKS_FILE ?= "${FILE_DIRNAME}/${IMAGE_BASENAME}.${MACHINE}.wks"

IMAGE_CMD_wic () {
	out="${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}"
	wks="${IMAGE_WKS_FILE}"
	[ -e $wks ] || wks="${FILE_DIRNAME}/${IMAGE_BASENAME}.wks"
	[ -e $wks ] || bbfatal "Kickstart file $wks doesn't exist"
	BUILDDIR=${TOPDIR} wic create $wks --vars ${STAGING_DIR_TARGET}/imgdata/ -e ${IMAGE_BASENAME} -o $out/
	mv $out/build/$(basename "${wks%.wks}")*.direct $out.rootfs.wic
	rm -rf $out/
}
