PR .= ".1"
do_compile_prepend () {
    sed -i -e 's#^LDFLAGS=.*#LDFLAGS = -L. ${LDFLAGS}#g' Makefile
}
