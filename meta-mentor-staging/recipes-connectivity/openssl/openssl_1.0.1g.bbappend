FILESEXTRAPATHS_prepend := "${THISDIR}/openssl:"
SRC_URI += "file://openssl-CVE-2014-0198.patch \
            file://openssl-CVE-2014-0195.patch"
