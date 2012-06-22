PRINC := "${@int(PRINC) + 1}"
do_configure_prepend () {
    sed -i -e 's,^ *NETHOME=.*$,NETHOME=${bindir},' \
           -e 's,^ *NETPERF=\./netperf$,NETPERF=${bindir}/netperf,' \
           -e 's,^ *NETPERF=/usr/bin/netperf$,NETPERF=${bindir}/netperf,' \
           -e 's,^ *NETPERF_CMD=.*$,NETPERF_CMD=${bindir}/netperf,' \
           doc/examples/*_script
}
