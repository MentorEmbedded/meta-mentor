FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"
SRC_URI_append_mel = "\
    file://setsid.cfg \
    file://resize.cfg \
"
