PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BP}:"

SRC_URI += "\
    file://commit-4ff16c2_imx_backport.patch \
    file://arm-tracehook/0001-ARM-add-support-for-the-generic-syscall.h-interface.patch \
    file://arm-tracehook/0002-ARM-add-TRACEHOOK-support.patch \
    file://arm-tracehook/0003-ARM-support-syscall-tracing.patch \
    file://arm-tracehook/0004-syscall.h-include-linux-sched.h.patch \
    file://0001-udp-add-tracepoints-for-queueing-skb-to-rcvbuf.patch \
    file://0001-core-add-tracepoints-for-queueing-skb-to-rcvbuf.patch \
    file://defconfig \
"
