# Disable assembly optimizations for X32, as its libav lacks the support
PACKAGECONFIG_remove_linux-gnux32 = "yasm"
LIBAV_EXTRA_CONFIGURE_COMMON_ARG_append_linux-gnux32 = " --disable-asm"
