PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS := "${THISDIR}/${BPN}"
SRC_URI += "\
    file://0001-Update-ARM-syscalls-instrumentation-to-version-3.5.6.patch \
"
