python () {
    if oe.utils.inherits(d, 'kernel') and not oe.utils.inherits(d, 'kernel-yocto'):
        d.appendVarFlag('do_unpack', 'postfuncs', ' enable_lttng2')
        d.appendVarFlag('do_unpack', 'vardeps', ' enable_lttng2')
        bb.debug(1, "Enabling lttng2 kernel options")
    else:
        bb.debug(1, "Not enabling lttng2 kernel options")
}

LTTNG2_OPTIONS_ENABLE = '\
    modules \
    kallsyms \
    high_res_timers \
    ftrace \
    tracepoints \
    have_syscall_tracepoints \
    perf_events \
    event_tracing \
    kprobes \
    kretprobes \
'

KERNEL_DEFCONFIG ?= "${WORKDIR}/defconfig"

enable_lttng2 () {
    if [ ! -e ${KERNEL_DEFCONFIG} ] || ! echo "${KERNEL_DEFCONFIG}" | grep -q "^${WORKDIR}/"; then
        return
    fi

    if grep -q "CONFIG_LTT[= ]" ${KERNEL_DEFCONFIG}; then
        # lttng 1.x patched in, disable enabling of lttng2
        return
    fi

    for option in ${LTTNG2_OPTIONS_ENABLE}; do
        option="CONFIG_$(echo $option | tr 'a-z' 'A-Z')"
        sed -i "/$option=/d" ${KERNEL_DEFCONFIG}
        echo "$option=y" >>${KERNEL_DEFCONFIG}
    done
}
