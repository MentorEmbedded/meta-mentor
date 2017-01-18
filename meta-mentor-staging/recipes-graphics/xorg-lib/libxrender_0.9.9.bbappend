FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://CVE-2016-7950-libxrender-Avoid-OOB-write.patch \
            file://CVE-2016-7949-libxrender-validate-lengths.patch \
	   "

