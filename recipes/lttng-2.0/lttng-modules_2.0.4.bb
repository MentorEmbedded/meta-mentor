SECTION = "devel"
SUMMARY = "Linux Trace Toolkit KERNEL MODULE"
DESCRIPTION = "The lttng-modules 2.0 package contains the kernel tracer modules"
LICENSE = "LGPLv2.1 & GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1eb086682a7c65a45acd9bcdf6877b3e \
                    file://gpl-2.0.txt;md5=751419260aa954499f7abaabaa882bbe \
                    file://lgpl-2.1.txt;md5=243b725d71bb5df4a1e5920b344b86ad"

DEPENDS = "virtual/kernel"

inherit module

PR = "r2"

SRC_URI = "http://lttng.org/files/${PN}/${PN}-${PV}.tar.bz2\
           file://lttng-modules-replace-KERNELDIR-with-KERNEL_SRC.patch\
	   file://0001-Add-net-probes.patch\
	   file://0002-Add-asoc-probes.patch\
	   file://0003-Add-ext3-probes.patch\
	   file://0004-Add-gpio-probes.patch\
	   file://0005-Add-jbd2-probes.patch\
	   file://0006-Add-jbd-probes.patch\
	   file://0007-Add-kmem-probes.patch\
	   file://0008-Add-module-probes.patch\
	   file://0009-Add-napi-probes.patch\
	   file://0010-Add-power-probes.patch\
	   file://0011-Add-regulator-probes.patch\
	   file://0012-Add-scsi-probes.patch\
	   file://0013-Add-skb-probes.patch\
	   file://0014-Add-sock-probes.patch\
	   file://0015-Add-udp-probes.patch\
	   file://0016-Add-vmscan-probes.patch\
	   file://0017-Add-lock-probes.patch\
	   file://0018-Fix-ring_buffer_frontend.c-missing-include-lttng-tra.patch\
	   file://0019-Fix-cleanup-move-lttng-tracer-core.h-include-to-lib-.patch\
           "
SRC_URI_append_pandaboard = "file://add_sched_process_exec_event.patch"
SRC_URI[md5sum] = "e2f07c0eb40a0d8027de17f4dd7ebe12"
SRC_URI[sha256sum] = "f00116c388289192774c774581a651832be094aeb6da2f2c0f9c9e275fed2d14"

export INSTALL_MOD_DIR="kernel/lttng-modules"
export KERNEL_SRC="${STAGING_KERNEL_DIR}"

# Due to liburcu not building for MIPS currently this recipe needs to
# be limited also.
# So here let us first suppport x86/arm/powerpc platforms now.
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*)-linux.*'
