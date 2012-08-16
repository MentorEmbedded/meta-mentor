SECTION = "devel"
SUMMARY = "Linux Trace Toolkit Control"
DESCRIPTION = "The Linux trace toolkit is a suite of tools designed \
to extract program execution details from the Linux operating system \
and interpret them."

LICENSE = "GPLv2 & LGPLv2.1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=61273c2e3f60dd38a74b01beb5f51fbd \
                    file://gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://lgpl-2.1.txt;md5=0f0d71500e6a57fd24d825f33242b9ca"

DEPENDS = "liburcu popt lttng2-ust"

PR = "r0"

SRC_URI = "http://lttng.org/files/${PN}/${PN}-${PV}.tar.bz2"
SRC_URI[md5sum] = "360d0e0e70ed11eda5aa1570ebc9c155"
SRC_URI[sha256sum] = "cc538f420bfe716220169e41b572d0cb8a345afb552faef924bfb2c625d92b0d"

inherit autotools

export KERNELDIR="${STAGING_KERNEL_DIR}"

FILES_${PN} += "${libdir}/lttng/libexec/*"
FILES_${PN}-dbg += "${libdir}/lttng/libexec/.debug"

# Due to liburcu not building for MIPS currently this recipe needs to
# be limited also.
# So here let us first suppport x86/arm/powerpc platforms now.
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*)-linux.*'
