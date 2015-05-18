FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/${BPN}:"
SRC_URI_append_class-native = " file://sync_file_range.patch"
