CPPFLAGS := "${@oe_filter_out('-D', CPPFLAGS, d)}"
CFLAGS := "${@oe_filter_out('-[Wf]', CFLAGS, d)}"

EXTRA_OEMAKE = "\
    'CC=${CC}' \
    'CFLAGS=${CFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
    \
    'USE_DNS=' \
    'NO_TCP_WRAPPER=${@base_contains('PACKAGECONFIG', 'tcpwrappers', '', '1', d)}' \
"

do_patch[postfuncs] += "adjust_paths"
do_patch[vardeps] += "adjust_paths"

adjust_paths () {
    sed -i -e 's,/sbin,${base_sbindir},; s,/usr/share/man/,${mandir}/,' ${S}/Makefile
}
