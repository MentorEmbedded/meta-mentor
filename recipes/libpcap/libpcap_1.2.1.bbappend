PRINC := "${@int(PRINC) + 2}"

do_configure_prepend () {
    sed -i -e's,^V_RPATH_OPT=.*$,V_RPATH_OPT=,' ${S}/pcap-config.in
}
