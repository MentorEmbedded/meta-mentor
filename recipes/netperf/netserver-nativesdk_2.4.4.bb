DESCRIPTION="Server for the NETPERF network performance benchmark including tests for TCP, UDP, sockets, ATM and more."
SECTION = "console/network"
HOMEPAGE = "http://www.netperf.org/"
LICENSE = "netperf"

SRC_URI="ftp://ftp.netperf.org/netperf/archive/netperf-${PV}.tar.bz2 \
	 file://netperf-2.4.x-svnr160-x8664fix.patch"

SRC_URI[md5sum] = "0e942f22864e601406a994420231075b"
SRC_URI[sha256sum] = "28e76af491ea3696885e4558ae2f5628a4b9ebdbefc2f1d9cf1b35db2813e497"

inherit autotools nativesdk

S = "${WORKDIR}/netperf-${PV}"

CFLAGS += "-DDO_UNIX -DDO_IPV6"

do_compile() {
	oe_runmake -C src netserver
}

do_install() {
	install -d ${D}${base_bindir}
	install -m 0755 src/netserver ${D}${base_bindir}/
}
