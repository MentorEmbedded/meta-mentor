# MEL supports BSP kernel versions which upstream doesn't care about.
# Remove -I/usr/local/include from the default INCLUDES
EXTRA_OEMAKE_append_mel = " 'INCLUDES=-I. $(CONFIG_INCLUDES)'"
