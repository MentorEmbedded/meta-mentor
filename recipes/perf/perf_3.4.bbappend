PRINC := "${@int(PRINC) + 2}"

do_configure_prepend () {
    sed -i 's,-Werror ,,' ${S}/tools/perf/Makefile
}

# We already pass the correct arguments to our compiler for the CFLAGS (if we
# don't override it, it'll add -m32/-m64 itself). For LDFLAGS, it was failing
# to find bfd symbols.
EXTRA_OEMAKE += "'CFLAGS=${CFLAGS}' \
                 'LDFLAGS=${LDFLAGS} -lpthread -lrt -lelf -lm -lbfd'"
