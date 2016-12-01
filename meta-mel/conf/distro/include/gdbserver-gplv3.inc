# If ALLOW_GPLV3_GDBSERVER is set, whitelist {L,}GPLv3 for the gdb recipes
ALLOW_GPLV3_GDBSERVER ?= ""
WHITELIST_GPL-3.0 += "${@'gdbserver-external gdb' if '${ALLOW_GPLV3_GDBSERVER}' else ''}"
WHITELIST_LGPL-3.0 += "${@'gdb' if '${ALLOW_GPLV3_GDBSERVER}' else ''}"

# If GPL-3.0 is in INCOMPATIBLE_LICENSE, and gdbserver/gdb isn't whitelisted,
# then remove gdbserver from the codebench-debug image feature, otherwise the
# build will fail.
FEATURE_PACKAGES_codebench-debug_remove = "${@'gdbserver' if gdbserver_is_incompatible(d) else ''}"

def gdbserver_is_incompatible(d):
    return incompatible_license_contains('GPL-3.0', not gdbserver_is_whitelisted(d), False, d)

def gdbserver_is_whitelisted(d):
    gdbserver_recipes = ['gdbserver-external', 'gdb']
    gplv3_lics = ['GPL-3.0']
    for flag, value in d.getVarFlags('SPDXLICENSEMAP').items():
        if value == 'GPL-3.0':
            gplv3_lics.append(flag)

    for lic in gplv3_lics:
        wval = (d.getVar('WHITELIST_' + lic, True) or '').split()
        if any(i in wval for i in gdbserver_recipes):
            return True
    return False
