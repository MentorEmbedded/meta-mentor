FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://openssh-CVE-2014-2532.patch \
            file://openssh-CVE-2014-2653.patch"

PARALLEL_MAKEINST = ""
