FILESEXTRAPATHS_prepend := "${THISDIR}/openssl:"
SRC_URI += "file://openssl-CVE-2014-0198.patch \
	    file://openssl-CVE-2014-0195.patch \
	    file://openssl-CVE-2014-3470.patch \
	    file://openssl-CVE-2014-0221.patch \
	    file://openssl-CVE-2014-0224-2.patch \
	    file://openssl-CVE-2014-0224.patch \
	"
