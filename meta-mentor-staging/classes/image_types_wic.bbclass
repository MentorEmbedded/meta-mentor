WKS_FILE ?= "${FILE_DIRNAME}/${IMAGE_BASENAME}.${MACHINE}.wks"
WKS_SEARCH_PATH ?= "\
    ${COREBASE}/scripts/lib/wic/canned-wks \
    \
    ${@' '.join('%s/scripts/lib/wic/canned-wks' % l for l in '${BBLAYERS}'.split())} \
    ${@' '.join('%s/wks' % l for l in '${BBLAYERS}'.split())} \
"
WKS_FULL_PATH = "${@wic_which('${WKS_FILE}', '${WKS_SEARCH_PATH}'.split(), '${WKS_FILE}') if not os.path.isabs('${WKS_FILE}') else '${WKS_FILE}'}"

def wic_which(path, search_paths, default=None):
    for search_path in search_paths:
        check_path = os.path.join(search_path, path)
        if os.path.exists(check_path):
            return check_path
    return default

WIC_EXTRA_ARGS ?= ""

IMAGE_CMD_wic () {
	out="${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}"
	wks="${WKS_FULL_PATH}"
	if [ ! -e "$wks" ]; then
	    bbfatal "Kickstart file $wks doesn't exist"
	fi

	BUILDDIR="${TOPDIR}" wic create "$wks" --vars "${STAGING_DIR_TARGET}/imgdata/" -e "${IMAGE_BASENAME}" -o "$out/" ${WIC_EXTRA_ARGS}
	mv "$out/build/$(basename "${wks%.wks}")"*.direct "$out.rootfs.wic"
	rm -rf "$out/"
}

IMAGE_CMD_wic[file-checksums] = "${WKS_FULL_PATH}"
