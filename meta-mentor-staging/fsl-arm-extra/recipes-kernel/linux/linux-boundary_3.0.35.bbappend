FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}-${PV}:"
SRC_URI += "file://fix_getrusage_for_perf.patch"
