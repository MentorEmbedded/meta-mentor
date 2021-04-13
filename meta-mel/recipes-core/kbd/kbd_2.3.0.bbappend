SRC_URI_prepend_mel = "git://github.com/MentorEmbedded/kbd;branch=2.2 "
SRC_URI_remove_mel := "${KERNELORG_MIRROR}/linux/utils/${BPN}/${BP}.tar.xz"
SRCREV_mel = "0d3810830ad84adc4b9cd0819162d8516b2768b2"
S_mel = "${WORKDIR}/git"

DEPENDS_append_mel = " bison-native"
