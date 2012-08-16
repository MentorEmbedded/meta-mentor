SECTION = "devel"
SUMMARY = "Linux Trace Toolkit KERNEL MODULE"
DESCRIPTION = "The lttng-modules 2.0 package contains the kernel tracer modules"
LICENSE = "LGPLv2.1 & GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1eb086682a7c65a45acd9bcdf6877b3e \
                    file://gpl-2.0.txt;md5=751419260aa954499f7abaabaa882bbe \
                    file://lgpl-2.1.txt;md5=243b725d71bb5df4a1e5920b344b86ad"

DEPENDS = "virtual/kernel"

inherit module

PR = "r0"

SRC_URI = "http://lttng.org/files/${PN}/${PN}-${PV}.tar.bz2\
           file://lttng-modules-replace-KERNELDIR-with-KERNEL_SRC.patch"
SRC_URI[md5sum] = "e2f07c0eb40a0d8027de17f4dd7ebe12"
SRC_URI[sha256sum] = "f00116c388289192774c774581a651832be094aeb6da2f2c0f9c9e275fed2d14"

export INSTALL_MOD_DIR="kernel/lttng-modules"
export KERNEL_SRC="${STAGING_KERNEL_DIR}"

# Due to liburcu not building for MIPS currently this recipe needs to
# be limited also.
# So here let us first suppport x86/arm/powerpc platforms now.
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*)-linux.*'
