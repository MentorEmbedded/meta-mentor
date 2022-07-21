# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# If ALLOW_GPLV3_GDBSERVER is set, allow {L,}GPLv3 for the gdb recipes
ALLOW_GPLV3_GDBSERVER ?= ""
INCOMPATIBLE_LICENSE_EXCEPTIONS += "\
    ${@'gdbserver-external:GPL-3.0 gdb:GPL-3.0' if '${ALLOW_GPLV3_GDBSERVER}' else ''} \
    ${@'gdb:LGPL-3.0' if '${ALLOW_GPLV3_GDBSERVER}' else ''} \
"

# If GPL-3.0 is in INCOMPATIBLE_LICENSE, and gdbserver/gdb isn't whitelisted,
# then remove gdbserver from the codebench-debug image feature, otherwise the
# build will fail.
FEATURE_PACKAGES_codebench-debug:remove = "${@'gdbserver' if any_incompatible(d, ['gdbserver-external', 'gdb'], 'GPL-3.0-only') else ''}"

INHERIT += "incompatible-packages-check"
