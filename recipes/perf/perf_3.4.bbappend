PRINC := "${@int(PRINC) + 1}"

do_configure_prepend () {
    sed -i 's,-Werror ,,' ${S}/tools/perf/Makefile
}
