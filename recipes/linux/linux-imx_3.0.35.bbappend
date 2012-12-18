FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_imx6qsabrelite = " file://fix_of_getrusage.patch"
