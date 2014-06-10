FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://parallel-make.patch \
            file://dnsmasq-CVE-2013-0198.patch"

EXTRA_OEMAKE += "\
    'CFLAGS=${CFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
"
