FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI_append_class-target = " file://ldflags-tests.patch"
