PV .= "+git${SRCPV}"
SRCREV = "d3ac4d63d21c643df5b09d9d7888eb0c4122379c"
PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://fix-arm-syscall-bloat.patch"
SRC_URI_append_imx6qsabrelite = " file://add_sched_process_exec_event.patch"
SRC_URI_append_p4080ds = " file://add_sched_process_exec_event.patch"
SRC_URI_append_p2020rdb = " file://add_sched_process_exec_event.patch"

COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*|mips.*)-linux.*'
