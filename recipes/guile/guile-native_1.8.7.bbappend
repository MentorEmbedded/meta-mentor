PRINC := "${@int(PRINC) + 1}"
BPV := "${@'.'.join(PV.split('.')[:2])}"

do_install_append() {
	install -m 0755  ${D}${bindir}/guile ${D}${bindir}/${HOST_SYS}-guile

	create_wrapper ${D}/${bindir}/guile \
		GUILE_LOAD_PATH=${STAGING_DATADIR_NATIVE}/guile/${BPV} \
		GUILE_LOAD_COMPILED_PATH=${STAGING_LIBDIR_NATIVE}/guile/${BPV}/ccache
	create_wrapper ${D}${bindir}/${HOST_SYS}-guile \
		GUILE_LOAD_PATH=${STAGING_DATADIR_NATIVE}/guile/${BPV} \
		GUILE_LOAD_COMPILED_PATH=${STAGING_LIBDIR_NATIVE}/guile/${BPV}/ccache

	sed -i '1s,^#!.*,#!${USRBINPATH}/env guile,' ${D}${bindir}/guile-config
}
