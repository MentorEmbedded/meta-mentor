PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}/irda-utils:"
SRC_URI += "file://ldflags.patch"

EXTRA_OEMAKE = "\
    'CC=${CC}' \
    'LD=${LD}' \
    'CFLAGS=${CFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
"

do_compile () {
	oe_runmake
}
