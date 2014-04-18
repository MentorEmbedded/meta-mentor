DEPENDS += "bc-native"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI +="file://fix_kernel_load_1.patch \
	   file://fix_kernel_load_2.patch"
