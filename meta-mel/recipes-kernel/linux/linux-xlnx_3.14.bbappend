FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
    file://openamp.cfg \
    file://0001-openamp-integrate-OpenAMP-support.patch \
"
