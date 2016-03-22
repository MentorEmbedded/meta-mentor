DESCRIPTION = "Preloader mkpimage tool"
SECTION = "bootloader"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://../COPYING;startline=17;md5=057bf9e50e1ca857d0eb97bfe4ba8e5d"
PROVIDES += "mkpimage"

SRCREV = "62c9a8c000996a2c82078d0ea0fa8315c7b34e0b"
SRC_URI = "git://git.pengutronix.de/git/barebox.git;protocol=git;branch=master"
S = "${WORKDIR}/git/scripts"

BBCLASSEXTEND = "native nativesdk"
EXTRA_OEMAKE = 'HOSTCC="${CC}" HOSTLD="${LD}" HOSTLDFLAGS="${LDFLAGS}" HOSTSTRIP=true'

do_configure () {
	if test -f ${S}/socfpga_mkimage
	then
		rm -rf ${S}/socfpga_mkimage
	fi
}

do_compile () {
	oe_runmake socfpga_mkimage
}

do_install () {
	install -d ${D}${bindir}
	install -m 0755 ${S}/socfpga_mkimage ${D}${bindir}/mkpimage
}
