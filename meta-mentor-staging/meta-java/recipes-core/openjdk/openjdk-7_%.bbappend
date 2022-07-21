# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/files:"

ICEDTEAPATCHES:append:feature-mentor-staging = "\
    file://icedtea-flags-to-compile-with-GCC-6.patch;apply=no \
    file://icedtea-specify-overloaded-variant-of-fmod.patch;apply=no \
"

DISTRIBUTION_PATCHES:append:feature-mentor-staging = "\
    patches/icedtea-flags-to-compile-with-GCC-6.patch \
    patches/icedtea-specify-overloaded-variant-of-fmod.patch \
"

FILES:${JDKPN}-jdk:append:feature-mentor-staging = " ${JDK_HOME}/tapset "

EXTRA_OEMAKE:append:feature-mentor-staging = " LDFLAGS_HASH_STYLE='${LDFLAGS}'"

INSANE_SKIP:${JDKPN}-vm-zero:append:feature-mentor-staging = " textrel"

python () {
    if 'feature-mentor-staging' in d.getVar('OVERRIDES').split(':'):
        d.setVarFlag('DISTRIBUTION_PATCHES', 'export', 1)
}
