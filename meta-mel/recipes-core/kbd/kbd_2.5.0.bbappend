# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SRC_URI:prepend:mel = "git://github.com/MentorEmbedded/kbd;branch=2.5;protocol=https "
SRC_URI:remove:mel := "${KERNELORG_MIRROR}/linux/utils/${BPN}/${BP}.tar.xz"
SRCREV:mel = "57b52a3f3cef3b6ba144c85fc62b3d3c8f83e4cf"
S:mel = "${WORKDIR}/git"

DEPENDS:append:mel = " bison-native"

# Don't exclude autopoint
EXTRA_AUTORECONF:mel = ""
