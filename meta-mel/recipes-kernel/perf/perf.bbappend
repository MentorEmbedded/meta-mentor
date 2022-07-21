# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# MEL supports BSP kernel versions which upstream doesn't care about.
# Remove -I/usr/local/include from the default INCLUDES
EXTRA_OEMAKE:append:mel = " 'INCLUDES=-I. $(CONFIG_INCLUDES)'"
