PRINC := "${@int(PRINC) + 1}"
do_configure () {
    sed -i 's#LINK_FLAGS=.*#LINK_FLAGS=$(LDFLAGS)#' src/Makefile
}
