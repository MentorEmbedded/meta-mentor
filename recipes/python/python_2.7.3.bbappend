PR .= ".1"

do_install_prepend () {
    install -d ${D}${bindir}
}
