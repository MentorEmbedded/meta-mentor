# This class provides a hook to set variables in the SDK environment-setup
# script to the values they have at image construction time, rather than the
# values they had in meta-environment.
SDK_RESET_ENV_SCRIPT_VARS ?= ""

SDK_POSTPROCESS_COMMAND_prepend = "adjust_environment_scripts;"

python adjust_environment_scripts () {
    # Handle multilibs in the SDK environment, siteconfig, etc files...
    localdata = bb.data.createCopy(d)

    # make sure we only use the WORKDIR value from 'd', or it can change
    localdata.setVar('WORKDIR', d.getVar('WORKDIR'))

    # make sure we only use the SDKTARGETSYSROOT value from 'd'
    localdata.setVar('SDKTARGETSYSROOT', d.getVar('SDKTARGETSYSROOT'))
    localdata.setVar('libdir', d.getVar('target_libdir', False))

    # Process DEFAULTTUNE
    bb.build.exec_func("adjust_environment_script", localdata)

    variants = d.getVar("MULTILIB_VARIANTS") or ""
    for item in variants.split():
        # Load overrides from 'd' to avoid having to reset the value...
        overrides = d.getVar("OVERRIDES", False) + ":virtclass-multilib-" + item
        localdata.setVar("OVERRIDES", overrides)
        localdata.setVar("MLPREFIX", item + "-")
        bb.build.exec_func("adjust_environment_script", localdata)
}

REAL_MULTIMACH_TARGET_SYS = "${TUNE_PKGARCH}${TARGET_VENDOR}-${TARGET_OS}"

adjust_environment_script () {
    script="${SDK_OUTPUT}/${SDKPATH}/environment-setup-${REAL_MULTIMACH_TARGET_SYS}"
    if [ ! -e "$script" ]; then
        bbwarn "adjust_environment_script: $script does not exist"
        return
    fi
    while read -r var value; do
        if [ -n "$var" ]; then
            sed -Ei -e "/(export )?$var=/s/=.*/=\"$value\"/" "$script"
        fi
    done <<END
${@shell_get_vars(d, '${SDK_RESET_ENV_SCRIPT_VARS}')}
END
}
adjust_environment_script[vardeps] += "${SDK_RESET_ENV_SCRIPT_VARS}"

def shell_get_vars(d, bbvars):
    """Return var/value pairs for use in a shell while loop.

    Example usage:

    while read -r var value; do
    done <<END
    $'{@shell_get_vars(d, 'FOO BAR')}
    END
    """
    if isinstance(bbvars, str):
        bbvars = bbvars.split()
    lines = []
    for var in bbvars:
        lines.append('{0} {1}\n'.format(var, d.getVar(var, True)))
    return ''.join(lines)

def shell_vars(d, bbvars, indent='    '):
    """Return var=value lines to set them as shell variables."""
    import subprocess
    if isinstance(bbvars, str):
        bbvars = bbvars.split()
    lines = []
    for var in bbvars:
        value = d.getVar(var, True)
        lines.append('{0}{1}={2}\n'.format(indent, var, subprocess.list2cmdline([value])))
    return ''.join(lines)[len(indent):]
