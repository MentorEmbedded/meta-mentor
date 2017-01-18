FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://CVE-2016-7947-CVE-2016-7948-libxrandr.patch \
	   "
