# Remove -I/usr/local/include from the default INCLUDES
EXTRA_OEMAKE += "'INCLUDES=-I. $(CONFIG_INCLUDES)'"
