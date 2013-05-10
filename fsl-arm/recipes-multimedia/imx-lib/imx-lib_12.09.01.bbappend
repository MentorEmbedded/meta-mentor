PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://ldflags.patch"
EXTRA_OEMAKE += "'LDFLAGS=${LDFLAGS}'"
