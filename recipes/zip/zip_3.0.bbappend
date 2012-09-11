PRINC := "${@int(PRINC) + 1}"

do_compile() {
    oe_runmake -f unix/Makefile flags
    sed -i 's#LFLAGS1=""#LFLAGS1="${LDFLAGS}"#' flags
    oe_runmake -f unix/Makefile generic
}
