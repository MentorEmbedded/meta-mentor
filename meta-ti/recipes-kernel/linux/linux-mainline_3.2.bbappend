FILESEXTRAPATHS_prepend :="${THISDIR}:${THISDIR}/${PN}:"
SRC_URI += "file://fix_getrusage_for_perf.patch \
	    file://files/fix_kernel_load_1.patch \
	    file://files/fix_kernel_load_2.patch \
	"



