PRINC := "${@int(PRINC) + 2}"

FILESEXTRAPATHS := "${THISDIR}/${BPN}"
SRC_URI += "\
    file://0001-Update-ARM-syscalls-instrumentation-to-version-3.5.6.patch \
    file://0002-Add-support-for-syscall-version-3.8-on-top-of-3.5.6.patch \
"
