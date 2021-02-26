SRC_URI_prepend_mel = "git://github.com/MentorEmbedded/kbd;branch=2.4 "
SRC_URI_remove_mel := "${KERNELORG_MIRROR}/linux/utils/${BPN}/${BP}.tar.xz"
SRCREV_mel = "a95b34e0f4c78be7e3c137613b3d8c161ab322ba"
S_mel = "${WORKDIR}/git"

DEPENDS_append_mel = " bison-native"
