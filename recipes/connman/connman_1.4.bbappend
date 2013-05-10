PR .= ".1"

DEPENDS := "${@oe_filter_out('gnutls$', DEPENDS, d)}"
PACKAGECONFIG ?= "wispr"
# WISPr support for logging into hotspots, requires TLS
PACKAGECONFIG[wispr] = "--enable-wispr,--disable-wispr,gnutls,"

do_install_prepend () {
	touch tools/wispr
}

do_install_append () {
	rm -f ${D}${bindir}/wispr
}
