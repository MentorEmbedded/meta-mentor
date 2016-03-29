FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_x86-64 += "file://0001-Fix-regression-tests.patch \
                         "
