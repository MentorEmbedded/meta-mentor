inherit kernel cml1-config kernel-config-lttng kernel-config-systemd
require recipes-kernel/linux/linux-dtb.inc

DESCRIPTION = "Linux kernel for Freescale platforms"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

require recipes-kernel/linux/linux-qoriq-sdk.inc

DEPENDS += "lzop-native bc-native libgcc"
UPSTREAM_PR = "1"
PV = "3.8.13-rt9-fsl-${UPSTREAM_PR}"
COMPATIBLE_MACHINE = "(p1010rdb|p4080ds|p2020rdb|p1020rdb)$"

KERNEL_SRC_URI ?= "http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/linux-qoriq-sdk-${PV}.tar.xz"
SRC_URI = "${KERNEL_SRC_URI} \
           file://nbd.cfg \
           file://autofs.cfg \
          "

SRC_URI[md5sum] = "c9262f6b2f847e1b9019322797bb5205"
SRC_URI[sha256sum] = "0437c160b2f74f56177a36f6fee8e28e1f03ebdd356430e7ab8a6a27d5e61e79"
S = "${WORKDIR}/${BP}"

DEFCONFIG = "${KERNEL_DEFCONFIG}"
KERNEL_CC_append = " ${TOOLCHAIN_OPTIONS}"
KERNEL_LD_append = " ${TOOLCHAIN_OPTIONS}"

do_install_append() {
    # vmlinux and modules binaries are required to build systemtap modules
    install -m 0644 vmlinux $kerneldir/
    find . -depth -name "*.ko" -print0 | cpio --null -pdlu $kerneldir
}

PACKAGES =+ " ${PN}-dbg "
FILES_${PN}-dbg += " \
                    ${KERNEL_SRC_PATH}/.debug/vmlinux \
                    ${KERNEL_SRC_PATH}/scripts/.debug \
                    ${KERNEL_SRC_PATH}/scripts/*/.debug \
"
