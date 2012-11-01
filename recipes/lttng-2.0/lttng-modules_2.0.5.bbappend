PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "\
    file://0001-Add-net-probes.patch \
    file://0002-Add-asoc-probes.patch \
    file://0003-Add-ext3-probes.patch \
    file://0004-Add-gpio-probes.patch \
    file://0005-Add-jbd2-probes.patch \
    file://0006-Add-jbd-probes.patch \
    file://0007-Add-kmem-probes.patch \
    file://0008-Add-module-probes.patch \
    file://0009-Add-napi-probes.patch \
    file://0010-Add-power-probes.patch \
    file://0011-Add-regulator-probes.patch \
    file://0012-Add-scsi-probes.patch \
    file://0013-Add-skb-probes.patch \
    file://0014-Add-sock-probes.patch \
    file://0015-Add-udp-probes.patch \
    file://0016-Add-vmscan-probes.patch \
    file://0017-Add-lock-probes.patch \
    file://0018-Fix-ring_buffer_frontend.c-missing-include-lttng-tra.patch \
    file://0019-Fix-cleanup-move-lttng-tracer-core.h-include-to-lib-.patch \
"

SRC_URI_append_pandaboard = "file://add_sched_process_exec_event.patch"
SRC_URI_append_imx6qsabrelite = "file://add_sched_process_exec_event.patch"
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*|mips.*)-linux.*'
