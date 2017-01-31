FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "\
           file://dosfstools-disable-iconv-conversion.patch \
"
