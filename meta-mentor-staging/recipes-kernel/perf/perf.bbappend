inherit incompatible-recipe-check

DEPENDS += "flex-native bison-native"

REMOVE_INCOMPATIBLE_MAN = "${@'man' if is_incompatible(d, ['libpipeline'], 'GPL-3.0') else ''}"
RDEPENDS_${PN}-doc_remove_mel = "${REMOVE_INCOMPATIBLE_MAN}"
