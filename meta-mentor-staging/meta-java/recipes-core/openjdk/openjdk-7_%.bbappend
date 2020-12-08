FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/files:"

ICEDTEAPATCHES_append_feature-mentor-staging = "\
    file://icedtea-flags-to-compile-with-GCC-6.patch;apply=no \
    file://icedtea-specify-overloaded-variant-of-fmod.patch;apply=no \
"

DISTRIBUTION_PATCHES_append_feature-mentor-staging = "\
    patches/icedtea-flags-to-compile-with-GCC-6.patch \
    patches/icedtea-specify-overloaded-variant-of-fmod.patch \
"

FILES_${JDKPN}-jdk_append_feature-mentor-staging = " ${JDK_HOME}/tapset "

EXTRA_OEMAKE_append_feature-mentor-staging = " LDFLAGS_HASH_STYLE='${LDFLAGS}'"

INSANE_SKIP_${JDKPN}-vm-zero_append_feature-mentor-staging = " textrel"

python () {
    if 'feature-mentor-staging' in d.getVar('OVERRIDES').split(':'):
        d.setVarFlag('DISTRIBUTION_PATCHES', 'export', 1)
}
