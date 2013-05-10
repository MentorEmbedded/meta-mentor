PR .= ".1"

DEPENDS += "gettext"

do_configure_prepend() {
	# autotools.bbclass only checks ${S}/po
	cp ${STAGING_DATADIR}/gettext/po/Makefile.in.in ${S}/lib/po/
}
