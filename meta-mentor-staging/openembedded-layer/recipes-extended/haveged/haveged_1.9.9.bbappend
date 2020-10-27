FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append_mel = " file://0001-fix-ordering-cycle-with-private-tmp.patch"
