FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

ICEDTEAPATCHES += "\
    file://icedtea-flags-to-compile-with-GCC-6.patch;apply=no \
    file://icedtea-specify-overloaded-variant-of-fmod.patch;apply=no \
"

DISTRIBUTION_PATCHES += "\
    patches/icedtea-flags-to-compile-with-GCC-6.patch \
    patches/icedtea-specify-overloaded-variant-of-fmod.patch \
"

export DISTRIBUTION_PATCHES

FILES_${JDKPN}-jdk_append = " ${JDK_HOME}/tapset "

EXTRA_OEMAKE_append = " LDFLAGS_HASH_STYLE='${LDFLAGS}'"

INSANE_SKIP_${JDKPN}-vm-zero_append = " textrel"
