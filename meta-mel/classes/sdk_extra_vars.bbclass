# In most cases, it's better to use environment-setup.d for this, but there
# are cases where it's useful to add to the main env setup script.

EXTRA_SDK_VARS ?= ""
EXTRA_EXPORTED_SDK_VARS ?= ""
EXTRA_SDK_LINES ?= ""

def sdk_extra_var_lines(d):
    lines = []
    for var in d.getVar('EXTRA_SDK_VARS', True).split():
        lines.append('%s="%s"' % (var, d.getVar(var, True) or ""))

    for var in d.getVar('EXTRA_EXPORTED_SDK_VARS', True).split():
        lines.append('export %s="%s"' % (var, d.getVar(var, True) or ""))

    extra_lines = d.getVar('EXTRA_SDK_LINES', True).replace('\\n', '\n').split('\n')
    lines.extend(extra_lines)
    return '\n'.join(lines)

toolchain_shared_env_script_append () {
    cat <<END >>"$script"
${@sdk_extra_var_lines(d)}
END
}
