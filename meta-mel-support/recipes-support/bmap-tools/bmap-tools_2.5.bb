SUMMARY = "Tools to generate block map (AKA bmap) and flash images using bmap"
DESCRIPTION = "Bmap-tools - tools to generate block map (AKA bmap) and flash images using \
bmap. Bmaptool is a generic tool for creating the block map (bmap) for a file, \
and copying files using the block map. The idea is that large file containing \
unused blocks, like raw system image files, can be copied or flashed a lot \
faster with bmaptool than with traditional tools like "dd" or "cp"."
HOMEPAGE = "http://git.infradead.org/users/dedekind/bmap-tools.git"
SECTION = "console/utils"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "ftp://ftp.infradead.org/pub/${BPN}/${BPN}-${PV}.tgz \
           file://Fiemap-synchronize-the-file-before-invoking-the-ioct.patch"
SRC_URI[md5sum] = "843522001b2aa2f7718f254f6942ad80"
SRC_URI[sha256sum] = "40fb0022ea5475e392fb2ef74b1e086e570951caec1745565e1a50ca35e75616"

RDEPENDS_${PN} = "python-core python-compression"

inherit setuptools

BBCLASSEXTEND = "native"

do_install_append_class-native() {
    sed -i -e 's|^#!.*/usr/bin/env python|#! /usr/bin/env nativepython|' ${D}${bindir}/bmaptool
}
