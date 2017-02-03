FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI_append_linux-gnux32 = " file://sandbox-x32-workaround.patch"
