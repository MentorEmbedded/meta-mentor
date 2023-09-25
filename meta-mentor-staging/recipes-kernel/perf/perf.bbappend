DEPENDS += "flex-native bison-native"

inherit incompatible-recipe-check

REMOVE_INCOMPATIBLE_MAN = "${@'man' if is_incompatible(d, ['libpipeline'], 'GPL-3.0') else ''}"
RDEPENDS_${PN}-doc_remove = "${REMOVE_INCOMPATIBLE_MAN}"

RDEPENDS_${PN}-tests += "bash"
