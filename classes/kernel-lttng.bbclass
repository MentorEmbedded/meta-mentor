python () {
    if oe.utils.inherits(d, 'kernel'):
        d.appendVarFlag('do_unpack', 'postfuncs', ' enable_lttng')
        d.appendVarFlag('do_unpack', 'vardeps', ' enable_lttng')
}

LTTNG_OPTIONS = '\
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

enable_lttng () {
    if [ ! -e ${WORKDIR}/defconfig ]; then
        return
    fi

    for option in ${LTTNG_OPTIONS}; do
        option="CONFIG_$(echo $option | tr 'a-z' 'A-Z')"
        sed -i "/$option=/d" ${WORKDIR}/defconfig
        echo "$option=y" >>${WORKDIR}/defconfig
    done
}
