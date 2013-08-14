PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI = "git://git.kernel.dk/blktrace.git;protocol=git \
           file://ldflags.patch"

EXTRA_OEMAKE = "\
    'CC=${CC}' \
    'CFLAGS=${CFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
"
PARALLEL_MAKE = ""

do_compile() {
	base_do_compile
}

do_install() {
	base_do_install
}
