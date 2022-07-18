# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

create_sdk_files:append () {
    script=${SDK_OUTPUT}/${SDKPATH}/environment-setup-${REAL_MULTIMACH_TARGET_SYS}
    cat >"${script}.new" <<END
if [ -n "\$BASH_SOURCE" ] || [ -n "\$ZSH_NAME" ]; then
    if [ -n "\$BASH_SOURCE" ]; then
        scriptdir="\$(cd "\$(dirname "\$BASH_SOURCE")" && pwd)"
    elif [ -n "\$ZSH_NAME" ]; then
        scriptdir="\$(cd "\$(dirname "\$0")" && pwd)"
    fi
else
    if [ ! -d "${SDKPATH}" ]; then
        echo >&2 "Warning: Unable to determine SDK install path from environment setup script location, using default of ${SDKPATH}."
    fi
    scriptdir="${SDKPATH}"
fi
END
    sed -e "s#${SDKPATH}#\$scriptdir#g" "$script" >>"${script}.new"
    mv "${script}.new" "${script}"
}
