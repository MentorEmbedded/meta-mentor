FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://parallel-make.patch"

EXTRA_OEMAKE += "\
    'CFLAGS=${CFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
"
