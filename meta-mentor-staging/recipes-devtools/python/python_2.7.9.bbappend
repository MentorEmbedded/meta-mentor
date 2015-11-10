FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://0001-ensure-usage-of-native-modules-while-cross-compiling.patch"
