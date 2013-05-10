PR .= ".3"

DEPENDS := "${@oe_filter_out('nautilus', DEPENDS, d)}"
PACKAGECONFIG ??= "nautilus"
PACKAGECONFIG[nautilus] = "--enable-nautilus-extension,--disable-nautilus-extension,nautilus"

do_configure_prepend() {
	sed -i -e "s: help : :g" ${S}/Makefile.am
}

FILES_${PN}-dev += "${libdir}/nautilus/extensions-2.0/*.la"
FILES_${PN}-staticdev += "${libdir}/nautilus/extensions-2.0/*.a"
FILES_${PN}-dbg += "${libdir}/nautilus/extensions-2.0/.debug"
