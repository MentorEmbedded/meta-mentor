FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://CVE-2016-7942-libx11-oob-read-operations.patch \
            file://CVE-2016-7943-libx11-out-of-boundary-access.patch \
	   "
