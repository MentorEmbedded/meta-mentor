FILESPATH .= ":${THISDIR}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fix_of_getrusage.patch \
           "
