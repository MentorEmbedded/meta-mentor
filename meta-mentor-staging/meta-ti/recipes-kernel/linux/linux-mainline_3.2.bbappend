FILESEXTRAPATHS_prepend := "${THISDIR}/files:${THISDIR}/${PN}:"
SRC_URI += "file://fix_getrusage_for_perf.patch \
	    file://fix_kernel_load_1.patch \
	    file://fix_kernel_load_2.patch \
	"
