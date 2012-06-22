require recipes-devtools/binutils/binutils_${PV}.bb
FILESEXTRAPATHS_prepend := "${COREBASE}/meta/recipes-devtools/binutils/binutils:"

BPN = "binutils"
S = "${WORKDIR}/${BP}"

do_install () {
	oe_runmake 'DESTDIR=${D}' install-bfd install-libiberty

	# Nuke .la file
	rm ${D}${libdir}/libbfd.la

	# Install the libiberty header
	install -d ${D}${includedir}
	install -m 644 ${S}/include/libiberty.h ${D}${includedir}
}

ALTERNATIVE_${PN}-symlinks = ""

BBCLASSEXTEND = ""
