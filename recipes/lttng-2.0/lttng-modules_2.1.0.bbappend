PV .= "+git${SRCPV}"
PRINC := "${@int(PRINC) + 2}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://fix-arm-syscall-bloat.patch"
SRC_URI_append_imx6qsabrelite = " file://add_sched_process_exec_event.patch"
SRC_URI_append_p4080ds = " file://add_sched_process_exec_event.patch"
SRC_URI_append_p2020rdb = " file://add_sched_process_exec_event.patch"

