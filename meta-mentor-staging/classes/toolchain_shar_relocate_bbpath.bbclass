TOOLCHAIN_SHAR_EXTRACT = "${@bb.utils.which(d.getVar('BBPATH'), 'files/toolchain-shar-extract.sh')}"
TOOLCHAIN_SHAR_RELOCATE = "${@bb.utils.which(d.getVar('BBPATH'), 'files/toolchain-shar-relocate.sh')}"
RELOCATE_SDK_SH = "${@bb.utils.which(d.getVar('BBPATH'), 'scripts/relocate_sdk.sh')}"

create_sdk_files_append () {
    install -m 0755 ${RELOCATE_SDK_SH} ${SDK_OUTPUT}/${SDKPATH}/relocate_sdk.sh
    sed -i -e "s:@SDKPATH@:${SDKPATH}:g; s:##DEFAULT_INSTALL_DIR##:$escaped_sdkpath:" ${SDK_OUTPUT}/${SDKPATH}/relocate_sdk.sh
}

python () {
    cs = d.getVar('create_shar', expand=False)
    if cs:
        cs = cs.replace('${COREBASE}/meta/files/toolchain-shar-extract.sh', '${TOOLCHAIN_SHAR_EXTRACT}')
        cs = cs.replace('${COREBASE}/meta/files/toolchain-shar-relocate.sh', '${TOOLCHAIN_SHAR_RELOCATE}')
        d.setVar('create_shar', cs)
}

do_populate_sdk[file-checksums] += "${TOOLCHAIN_SHAR_EXTRACT}:True"
do_populate_sdk[file-checksums] += "${TOOLCHAIN_SHAR_RELOCATE}:True"
do_populate_sdk[file-checksums] += "${RELOCATE_SDK_SH}:True"
