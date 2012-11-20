DESCRIPTION = "The userspace read-copy update library by Mathieu Desnoyers"
HOMEPAGE = "http://lttng.org/urcu"
BUGTRACKER = "http://lttng.org/project/issues"

# The one GPLv3 file is an m4 macro which isn't shipped in any form. The MIT
# code is linked against LGPL code, so is superceded. The GPLv2 code is
# exclusively the library's tests, which we aren't shipping at this time.
SOURCE_LICENSE = "LGPLv2.1+ & MIT-Style & GPLv2 & GPLv3"
LICENSE = "LGPLv2.1+"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0f060c30a27922ce9c0d557a639b4fa3 \
                    file://urcu.h;beginline=4;endline=32;md5=4de0d68d3a997643715036d2209ae1d9 \
                    file://urcu/uatomic/x86.h;beginline=4;endline=21;md5=220552f72c55b102f2ee35929734ef42"

PR = "r0"

SRC_URI = "http://lttng.org/files/urcu/userspace-rcu-${PV}.tar.bz2"

SRC_URI[md5sum] = "2c5083fac662ecd38d6076dffa86259b"
SRC_URI[sha256sum] = "0f7d4a1e0c6c6ecc75e7de0a4b80518c6ba93c97872981e196c758db7a2404e2"

S = "${WORKDIR}/userspace-rcu-${PV}"
CFLAGS_append_libc-uclibc = " -D_GNU_SOURCE"
inherit autotools
