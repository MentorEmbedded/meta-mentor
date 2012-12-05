PR .= ".1"

do_configure_prepend() {
	sed -i -e "s: help : :g" ${S}/Makefile.am
}
