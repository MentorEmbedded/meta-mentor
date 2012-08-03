SUMMARY = "AutoGen is a tool to manage programs that contain large amounts of repetitious text."
DESCRIPTION = "AutoGen is a tool designed to simplify the creation and\
 maintenance of programs that contain large amounts of repetitious text.\
 It is especially valuable in programs that have several blocks of text\
 that must be kept synchronized."
HOMEPAGE = "http://www.gnu.org/software/autogen/"
SECTION = "devel"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504" 

SRC_URI = "${GNU_MIRROR}/autogen/rel${PV}/autogen-${PV}.tar.gz"

SRC_URI[md5sum] = "16ce2836a5159cacd0d1e0988a4d9af3"
SRC_URI[sha256sum] = "e7029361186f85425146f81eac1676ff44fa4b365b7ee6d979190ec988e508b0"

PR = "r0"

DEPENDS = "guile-native libtool-native libxml2-native"
RDEPENDS = "automake pkgconfig"

inherit autotools native

# Following line will be needed for the non-native target recipe.
#CFLAGS += "-L${STAGING_LIBDIR} -lguile-2.0 -lgc -pthread -I${STAGING_INCDIR}/guile/2.0 -I${STAGING_INCDIR}"

do_install_append () {
	create_wrapper ${D}/${bindir}/autogen \
		GUILE_LOAD_PATH=${STAGING_DATADIR_NATIVE}/guile/2.0 \
		GUILE_LOAD_COMPILED_PATH=${STAGING_LIBDIR_NATIVE}/guile/2.0/ccache
}
