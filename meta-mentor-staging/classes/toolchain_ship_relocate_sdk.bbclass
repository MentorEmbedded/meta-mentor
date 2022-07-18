# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

RELOCATE_SDK_SH ?= "${@bb.utils.which(d.getVar('BBPATH'), 'scripts/relocate_sdk.sh')}"

create_sdk_files:append () {
    install -m 0755 ${RELOCATE_SDK_SH} ${SDK_OUTPUT}/${SDKPATH}/relocate_sdk.sh
    sed -i -e "s:@SDKPATH@:${SDKPATH}:g; s:##DEFAULT_INSTALL_DIR##:$escaped_sdkpath:" ${SDK_OUTPUT}/${SDKPATH}/relocate_sdk.sh
}

do_populate_sdk[file-checksums] += "${RELOCATE_SDK_SH}:True"
