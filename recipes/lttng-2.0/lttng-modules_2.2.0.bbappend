FILESEXTRAPATHS := "${THISDIR}/${BPN}"
SRC_URI += "\
    file://0001-Update-ARM-syscalls-instrumentation-to-version-3.5.6.patch \
    file://0001-Clean-up-using-global_dirty_limit-wrapper-for-writeb.patch \
"
