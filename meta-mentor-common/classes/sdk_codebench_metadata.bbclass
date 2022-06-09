# Write additiional metadata for CodeBench to the SDK when codebench-metadata is
# in SDKIMAGE_FEATURES.

inherit sdk_extra_vars cb-mbs-options

OVERRIDES =. "${@bb.utils.contains('SDKIMAGE_FEATURES', 'codebench-metadata', 'sdk-codebench-metadata:', '', d)}"

SOURCERY_VERSION ?= ""
CODEBENCH_SDK_VARS += "\
    MACHINE \
    DISTRO \
    DISTRO_NAME \
    DISTRO_VERSION \
    ADE_IDENTIFIER \
    ADE_SITENAME \
    ADE_VERSION \
    gdb_serverpath=${bindir}/gdbserver \
"
CODEBENCH_SDK_VARS:append:tcmode-external-sourcery = "\
    SOURCERY_VERSION \
    TOOLCHAIN_VERSION=${@d.getVar('SOURCERY_VERSION').split('-', 1)[0]} \
"
EXTRA_SDK_VARS:append:sdk-codebench-metadata = " ${CODEBENCH_SDK_VARS}"
SDK_POSTPROCESS_COMMAND:prepend:sdk-codebench-metadata = "adjust_sdk_script_codebench; write_codebench_metadata;"

adjust_sdk_script_codebench () {
    # Determine the script's location relative to itself rather than hardcoding it
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

    # Add variables from SDK_EXTRA_VARS
    cat <<END >>"$script"
${@sdk_extra_var_lines(d)}
END
}

python write_codebench_metadata () {
    localdata = bb.data.createCopy(d)

    # make sure we only use the WORKDIR value from 'd', or it can change
    localdata.setVar('WORKDIR', d.getVar('WORKDIR'))

    # make sure we only use the SDKTARGETSYSROOT value from 'd'
    localdata.setVar('SDKTARGETSYSROOT', d.getVar('SDKTARGETSYSROOT'))
    localdata.setVar('libdir', d.getVar('target_libdir', False))

    write_cb_mbs_options(localdata, localdata.expand('${SDK_OUTPUT}/${SDKPATH}/cb-mbs-options-${REAL_MULTIMACH_TARGET_SYS}'))

    if not d.getVar("MLPREFIX"):
        variants = d.getVar("MULTILIB_VARIANTS") or ""
        for item in variants.split():
            ld2 = localdata.createCopy()
            # Load overrides from 'd' to avoid having to reset the value...
            overrides = d.getVar("OVERRIDES", False) + ":virtclass-multilib-" + item
            ld2.setVar("OVERRIDES", overrides)
            ld2.setVar("MLPREFIX", item + "-")

            write_cb_mbs_options(ld2, ld2.expand('${SDK_OUTPUT}/${SDKPATH}/cb-mbs-options-${REAL_MULTIMACH_TARGET_SYS}'))
}
write_codebench_metadata[vardepsexclude] += "OVERRIDES"

def write_cb_mbs_options(d, optionsfile):
    # We don't care about flags like debugging, optimization. TUNE_CCARGS is
    # already covered.
    l = d.createCopy()
    l.setVar('TARGET_CFLAGS', '')
    l.setVar('TARGET_CXXFLAGS', '')
    l.setVar('TARGET_LDFLAGS', '')
    options = get_cb_options(l)
    bb.utils.mkdirhier(os.path.dirname(optionsfile))
    with open(optionsfile, 'w') as f:
        f.writelines('%s=%s\n' % (k, d.expand(v)) for k, v in sorted(options.items()))

write_cb_mbs_options[vardeps] += "${@' '.join('CB_MBS_OPTIONS[%s]' % f for f in (d.getVarFlags('CB_MBS_OPTIONS') or []))}"

