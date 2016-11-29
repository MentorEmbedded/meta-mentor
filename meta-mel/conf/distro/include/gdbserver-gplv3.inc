# If ALLOW_GPLV3_GDBSERVER is set, whitelist {L,}GPLv3 for the gdb recipes
ALLOW_GPLV3_GDBSERVER ?= ""
WHITELIST_GPL-3.0 += "${@'gdbserver-external gdb' if '${ALLOW_GPLV3_GDBSERVER}' else ''}"
WHITELIST_LGPL-3.0 += "${@'gdb' if '${ALLOW_GPLV3_GDBSERVER}' else ''}"

# If GPL-3.0 is in INCOMPATIBLE_LICENSE, and gdbserver/gdb isn't whitelisted,
# then remove gdbserver from the codebench-debug image feature, otherwise the
# build will fail.
FEATURE_PACKAGES_codebench-debug_remove = "${@'gdbserver' if is_incompatible(d, ['gdbserver-external', 'gdb'], 'GPL-3.0') else ''}"

INHERIT += "incompatible-recipe-check"
