SECTION = "devel"
SUMMARY = "Linux Trace Toolkit KERNEL MODULE"
DESCRIPTION = "The lttng-modules package contains the kernel tracer modules"
LICENSE = "LGPLv2.1 & GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1412caf5a1aa90d6a48588a4794c0eac \
                    file://gpl-2.0.txt;md5=751419260aa954499f7abaabaa882bbe \
                    file://lgpl-2.1.txt;md5=243b725d71bb5df4a1e5920b344b86ad"

SRC_URI = "\
    git://git.lttng.org/lttng-modules.git \
    file://0001-Update-ARM-syscalls-instrumentation-to-version-3.5.6.patch \
"

SRCREV = "v2.2.0-rc2"
PV = "2.1.1+2.2.0rc2"
PR = "r0"

inherit module

EXTRA_OEMAKE += "\
    'INSTALL_MOD_DIR=kernel/lttng-modules' \
    'KERNELDIR=${STAGING_KERNEL_DIR}' \
"

S = "${WORKDIR}/git"
