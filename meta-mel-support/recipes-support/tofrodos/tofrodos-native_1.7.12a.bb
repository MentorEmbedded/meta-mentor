# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

DESCRIPTION = "Tofrodos is a text file conversion utility that converts ASCII files between the MSDOS and unix format"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://../COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "http://tofrodos.sourceforge.net/download/tofrodos-${PV}.tar.gz \
           file://Make-OE-friendly.patch \
          "

SRC_URI[md5sum] = "219c03d7c58975b335cdb5201338125a"
SRC_URI[sha256sum] = "3098af78325486b99116c65c9f9bbbbfb3dfbeab1ab1e63a8da79550a5af6a08"

S = "${WORKDIR}/tofrodos/src"

inherit native

do_install(){
	mkdir -p ${D}/${bindir}/
	oe_runmake 'BINDIR=${D}${bindir}' install
}
