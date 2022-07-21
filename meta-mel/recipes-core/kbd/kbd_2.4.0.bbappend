# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SRC_URI:prepend:mel = "git://github.com/MentorEmbedded/kbd;branch=2.4;protocol=https "
SRC_URI:remove:mel := "${KERNELORG_MIRROR}/linux/utils/${BPN}/${BP}.tar.xz"
SRCREV:mel = "a95b34e0f4c78be7e3c137613b3d8c161ab322ba"
S:mel = "${WORKDIR}/git"

DEPENDS:append:mel = " bison-native"

# Don't exclude autopoint
EXTRA_AUTORECONF:mel = ""
