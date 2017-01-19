FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://CVE-2016-7945-CVE-2016-7946-libxi-OOB-memory-access.patch \
	   "
