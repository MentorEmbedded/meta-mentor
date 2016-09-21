# Automatically run our relocation scripts when necessary, when the user
# sources the environment setup script.
#
# If the sdk was installed with a method that can't run post-install scripts,
# then this will relocate the first time you source the script, otherwise
# it'll do so when the SDK install path changes (i.e. it was moved). To use
# this with the shar installer, you will want to pass -S when installing it,
# otherwise it will remove the relocation script this relies upon.

SDK_AUTO_RELOCATE_SOURCE ?= "1"
SDK_AUTO_RELOCATE_HOST_DEPENDS = "nativesdk-sdk-relocate"

# Ensure that the shar installer writes .installpath, so we don't relocate the
# first time the user sources the environment setup script in that case.
SDK_POST_INSTALL_COMMAND_append = 'echo "${env_setup_script%/*}" >"${env_setup_script%/*}/.installpath";'

sdkpath_to_bindir = "${@os.path.relpath('${SDKPATHNATIVE}${bindir_nativesdk}', '${SDKPATH}')}"

toolchain_env_script_reloc_fragment () {
    mv "$script" "$script.fragment"
    sed -i -e "s#${SDKPATH}#\$scriptdir#g" "$script.fragment" 
    cat >"$script" <<END
if [ -z "\$SDK_RELOCATING" ]; then
    if [ -n "\$BASH_SOURCE" ] || [ -n "\$ZSH_NAME" ]; then
        if [ -n "\$BASH_SOURCE" ]; then
            scriptdir="\$(cd "\$(dirname "\$BASH_SOURCE")" && pwd)"
        elif [ -n "\$ZSH_NAME" ]; then
            scriptdir="\$(cd "\$(dirname "\$0")" && pwd)"
        fi

        if [ -e "\$scriptdir/${sdkpath_to_bindir}/sdk-auto-relocate" ]; then
            env -i "\$scriptdir/${sdkpath_to_bindir}/sdk-auto-relocate" && SDK_RELOCATING=1 . "\$scriptdir/environment-setup-${REAL_MULTIMACH_TARGET_SYS}"
        else
            echo >&2 "Warning: Unable to find sdk-auto-relocate script"
        fi
    else
        echo >&2 "Warning: Unable to determine SDK install path from environment setup script location. Please run <installdir>/${sdkpath_to_bindir}/sdk-auto-relocate manually."
        scriptdir="${SDKPATH}"
    fi
else
    unset SDK_RELOCATING
fi
END
    cat "$script.fragment" >>"$script"
    rm "$script.fragment"
}

python () {
    if bb.utils.to_boolean(d.getVar('SDK_AUTO_RELOCATE_SOURCE', True)):
        d.appendVar('toolchain_create_sdk_env_script', '\n${toolchain_env_script_reloc_fragment}')
        d.appendVar('TOOLCHAIN_HOST_TASK', ' ${SDK_AUTO_RELOCATE_HOST_DEPENDS}')
}
