# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_LINKNAME ?= "${@'${TOOLCHAIN_OUTPUTNAME}'.replace('-${SDK_VERSION}', '')}"

SDK_POSTPROCESS_COMMAND:append = "create_sdk_link;"

create_sdk_link () {
    if [ "${TOOLCHAIN_OUTPUTNAME}" != "${TOOLCHAIN_LINKNAME}" ]; then
        for f in "${TOOLCHAIN_OUTPUTNAME}"*; do
            if [ -e "$f" ]; then
                ln -sf "$f" "${TOOLCHAIN_LINKNAME}${f#${TOOLCHAIN_OUTPUTNAME}}"
            fi
        done
    fi
}
create_sdk_link[dirs] = "${SDK_DEPLOY}"
