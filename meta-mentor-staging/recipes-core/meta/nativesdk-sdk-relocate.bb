LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"
REAL_MULTIMACH_TARGET_SYS := "${MULTIMACH_TARGET_SYS}"

inherit nativesdk toolchain_shar_relocate_bbpath

SDKTARGETSYSROOT = "${SDKPATH}/sysroots/${REAL_MULTIMACH_TARGET_SYS}"

bindir_to_sdkpath = "${@os.path.relpath('${SDKPATH}', '${SDKPATHNATIVE}${bindir_nativesdk}')}"
sdkpath_to_bindir = "${@os.path.relpath('${SDKPATHNATIVE}${bindir_nativesdk}', '${SDKPATH}')}"

do_compile () {
    cat <<END >sdk-relocate
#!/bin/sh
set -eu
scriptdir="\$(cd "\$(dirname "\$0")" && pwd -P)"
if [ \$# -gt 0 ]; then
    DEFAULT_INSTALL_DIR="\$1"
else
    DEFAULT_INSTALL_DIR="${SDKPATH}"
fi
if [ \$# -gt 1 ]; then
    installdir="\$2"
else
    installdir="\$(cd "\$scriptdir/${bindir_to_sdkpath}" && pwd -P)"
fi
SUDO_EXEC=
relocate=1
env_setup_script="\$installdir/environment-setup-${REAL_MULTIMACH_TARGET_SYS}"
target_sdk_dir="\$(cd "\$scriptdir/${bindir_to_sdkpath}" && pwd -P)"
sed -i -e "s#\$DEFAULT_INSTALL_DIR\>#\$installdir#g" "\$env_setup_script"
####
END
    cat "${TOOLCHAIN_SHAR_RELOCATE}" >>sdk-relocate
    sed -i -e 's#grep -v "\$target_sdk_dir/.*"#grep -Ev "(sdk-relocate|$target_sdk_dir/(environment-setup-*|\.installpath))"#' sdk-relocate
    sed -i -e '/native_sysroot=/a native_sysroot=$($SUDO_EXEC echo $native_sysroot | sed -e "s:\\$scriptdir:$target_sdk_dir:")' sdk-relocate

    cat <<END >sdk-auto-relocate
#!/bin/sh
set -eu
scriptdir="\$(cd "\$(dirname "\$0")" && pwd -P)"
installdir="\$(cd "\$scriptdir/${bindir_to_sdkpath}" && pwd -P)"
PATH="\$(echo "\$PATH" | tr : '\n' | grep -Fv "\$scriptdir" | tr '\n' : | sed 's,:\$,,')"
if [ -e "\$installdir/.installpath" ]; then
    from_path="\$(cat "\$installdir/.installpath")"
    if [ "\$from_path" = "\$installdir" ]; then
        exit 10
    fi
else
    from_path="${SDKPATH}"
fi
sh "\$scriptdir/sdk-relocate" "\$from_path" "\$installdir"
echo "\$installdir" >"\$installdir/.installpath"
END

    cat >sdk-relocate.sh <<END
if [ -z "\$SDK_RELOCATING" ]; then
    if [ -n "\$BASH_SOURCE" ] || [ -n "\$ZSH_NAME" ]; then
        if [ -n "\$BASH_SOURCE" ]; then
            scriptdir="\$(cd "\$(dirname "\$BASH_SOURCE")" && pwd)"
        elif [ -n "\$ZSH_NAME" ]; then
            scriptdir="\$(cd "\$(dirname "\$0")" && pwd)"
        fi

        env -i "\$scriptdir/${sdkpath_to_bindir}/sdk-auto-relocate" && SDK_RELOCATING=1 . "\$scriptdir/environment-setup-${REAL_MULTIMACH_TARGET_SYS}"
    else
        echo >&2 "Warning: Unable to determine SDK install path from environment setup script location. Please run <installdir>/${sdkpath_to_bindir}/sdk-auto-relocate manually."
    fi
else
    unset SDK_RELOCATING
fi
END
}

do_install () {
    install -d "${D}${bindir}" "${D}${SDKPATHNATIVE}/environment-setup.d"
    install -m 0755 sdk-relocate "${D}${bindir}/"
    install -m 0755 sdk-auto-relocate "${D}${bindir}/"
    install -m 0755 sdk-relocate.sh "${D}${SDKPATHNATIVE}/environment-setup.d/"
}

FILES_${PN} += "${SDKPATHNATIVE}/environment-setup.d"
