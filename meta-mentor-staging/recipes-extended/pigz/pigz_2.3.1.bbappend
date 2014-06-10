PIGZ_SYSROOT_DEPS = ""
PIGZ_SYSROOT_DEPS_class-native = "zlib-native:do_populate_sysroot_setscene"
do_populate_sysroot_setscene[depends] += "${PIGZ_SYSROOT_DEPS}"
