python () {
    if (oe.utils.inherits(d, 'kernel') and
        d.getVar('VIRTUAL-RUNTIME_lttng', True) != 'packagegroup-tools-lttng'):
        d.appendVarFlag('do_unpack', 'postfuncs', ' enable_lttng2')
        d.appendVarFlag('do_unpack', 'vardeps', ' enable_lttng2')
}

LTTNG2_OPTIONS = '\
    modules \
    kallsyms \
    high_res_timers \
    tracepoints \
    have_syscall_tracepoints \
    perf_events \
    event_tracing \
    kprobes \
    kretprobes \
'

enable_lttng2 () {
    if [ ! -e ${WORKDIR}/defconfig ]; then
        return
    fi

    for option in ${LTTNG2_OPTIONS}; do
        option="CONFIG_$(echo $option | tr 'a-z' 'A-Z')"
        sed -i "/$option=/d" ${WORKDIR}/defconfig
        echo "$option=y" >>${WORKDIR}/defconfig
    done
}
