FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://0004-Fix-compilation-with-ICU-59.patch"
DEPENDS += "flex-native bison-native"
