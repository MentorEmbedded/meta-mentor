PRINC := "${@int(PRINC) + 1}"

do_unpack[postfuncs] += "no_werror"
do_unpack[vardeps] += "no_werror"

no_werror () {
    sed -i 's,-Werror ,,' ${S}/tools/perf/Makefile
}
