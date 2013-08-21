PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS := "${THISDIR}/${BPN}"
SRC_URI += "\
    file://0001-Update-ARM-32-bit-syscall-tracepoints-to-3.4.patch \
"
