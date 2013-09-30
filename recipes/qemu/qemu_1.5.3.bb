require recipes-devtools/qemu/qemu.inc

DEPENDS += "gnutls"
DEPENDS_class-native += "gnutls-native"

FILESPATH .= ":${COREBASE}/meta/recipes-devtools/qemu/files"

LIC_FILES_CHKSUM = "file://COPYING;md5=441c28d2cf86e15a37fa47e15a72fbac \
                    file://COPYING.LIB;endline=24;md5=c04def7ae38850e7d3ef548588159913"

SRC_URI += "file://fdt_header.patch"

SRC_URI_prepend = "http://wiki.qemu.org/download/qemu-${PV}.tar.bz2"
SRC_URI[md5sum] = "7a7ce91bea6a69e55b3c6e20e4999898"
SRC_URI[sha256sum] = "39364ccbe82434c4eb8c25813896a1dce2db1977080d06ce13f96aa24ee2a601"

COMPATIBLE_HOST_class-target_mips64 = "null"
