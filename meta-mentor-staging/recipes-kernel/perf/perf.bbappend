DEPENDS += "flex-native bison-native"
REMOVE_MAN_RDEPENDS = "${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPLv3','man', '', d)}"
RDEPENDS_${PN}-doc_remove_mel = "${REMOVE_MAN_RDEPENDS}"
