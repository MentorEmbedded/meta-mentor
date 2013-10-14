do_install_class-target () {
	oe_runmake CC="${CC} ${CFLAGS}" LD="${LD} ${LDFLAGS}" INSTALLROOT="${D}" firmware="bios" install

	install -d ${D}${datadir}/syslinux/
	install -m 644 ${S}/bios/core/ldlinux.sys ${D}${datadir}/syslinux/
	install -m 644 ${S}/bios/core/ldlinux.bss ${D}${datadir}/syslinux/
}
