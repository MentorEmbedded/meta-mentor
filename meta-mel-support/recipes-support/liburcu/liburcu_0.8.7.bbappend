FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Fix segfault in lttng-ust while linking with liburcu-bp and liburcu-cds
# Should be removed when toolchain binutils is fixed !
SRC_URI_append_x86-64 = " \
		file://0001-Introduce-urcu_assert-and-registration-check.patch \
		file://0002-Detect-RCU-read-side-underflows.patch \
		file://0003-Detect-RCU-read-side-overflows.patch \
		file://0004-Add-a-compat-layer-for-syscall.h.patch \
		file://0005-urcu-bp-use-sys_membarrier-when-available.patch \
		"
