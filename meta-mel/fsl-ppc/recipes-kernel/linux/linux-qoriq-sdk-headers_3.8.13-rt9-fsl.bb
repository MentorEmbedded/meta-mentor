DESCRIPTION = "Linux kernel headers for Freescale platforms"
SECTION = "devel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

INHIBIT_DEFAULT_DEPS = "1"
PROVIDES += "linux-libc-headers"
RPROVIDES_${PN}-dev += "linux-libc-headers-dev"
RPROVIDES_${PN}-dbg += "linux-libc-headers-dbg"
RDEPENDS_${PN}-dev = ""
RRECOMMENDS_${PN}-dbg = "linux-libc-headers-dev (= ${EXTENDPKGV})"

UPSTREAM_PR = "1"
PV = "3.8.13-rt9-fsl-${UPSTREAM_PR}"
COMPATIBLE_MACHINE = "(p1010rdb|p4080ds|p2020rdb|p1020rdb)$"

KERNEL_SRC_URI ?= "http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/linux-qoriq-sdk-${PV}.tar.xz"
SRC_URI = "${KERNEL_SRC_URI}"
SRC_URI += "file://scripts-Makefile.headersinst-install-headers-from-sc.patch"
SRC_URI[md5sum] = "c9262f6b2f847e1b9019322797bb5205"
SRC_URI[sha256sum] = "0437c160b2f74f56177a36f6fee8e28e1f03ebdd356430e7ab8a6a27d5e61e79"
S = "${WORKDIR}/linux-qoriq-sdk-${PV}"

inherit kernel-arch

do_configure() {
        oe_runmake allnoconfig
}

do_compile () {
}

do_install() {
        oe_runmake headers_install INSTALL_HDR_PATH=${D}${exec_prefix}
        # Kernel should not be exporting this header
        rm -f ${D}${exec_prefix}/include/scsi/scsi.h

        # The ..install.cmd conflicts between various configure runs
        find ${D}${includedir} -name ..install.cmd | xargs rm -f
}
