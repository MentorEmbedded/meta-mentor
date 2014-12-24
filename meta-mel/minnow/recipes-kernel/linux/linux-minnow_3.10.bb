inherit kernel cml1-config kernel-config-lttng kernel-config-systemd

COMPATIBLE_MACHINE = "minnow"
DEFAULT_PREFERENCE = "-1"

DEPENDS += "lzop-native bc-native"

OVERRIDES .= "${@':minnow-rt' if '${RT_KERNEL_MINNOW}' == 'yes' else ''}"

KERNEL_NAME = "linux-yocto-minnow"
KERNEL_NAME_minnow-rt = "linux-yocto-preempt-rt-minnow"
KVERSION = "${@'${PV}'.replace('+git', '-')}"
KERNEL_SRC_NAME ?= "${KERNEL_NAME}-${KVERSION}"

SRC_URI = "\
    http://s3.amazonaws.com/portal.mentor.com/sources/MEL-2014.12/${KERNEL_SRC_NAME}.tar.xz;name=${KERNEL_NAME} \
    file://defconfig \
"
SRC_URI[linux-yocto-minnow.md5sum] = "6b13e9f5c45faa68d5a647dcd867d76e"
SRC_URI[linux-yocto-minnow.sha256sum] = "bf66203705bf5ff9cee563c720848380c1e92f52fb77cef00852f9e1c0b44fd6"
SRC_URI[linux-yocto-preempt-rt-minnow.md5sum] = "d73d5c89cd47e61a7d107e1579a0f6f0"
SRC_URI[linux-yocto-preempt-rt-minnow.sha256sum] = "8b021d27fef1de551ea76eaf23877b2a6877c712db1eae918c57e0f63610a4aa"

PV = "3.10.43+git2602-gf20d12e"
PV_minnow-rt = "3.10.54+git3035-g5f943e7"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

S = "${WORKDIR}/${KERNEL_SRC_NAME}"

DEFCONFIG = "${WORKDIR}/defconfig"

kernel_do_install_append() {
    # vmlinux and modules binaries are required to build systemtap modules
    install -m 0644 vmlinux $kerneldir/
    find . -depth -name "*.ko" -print0 | cpio --null -pdlu $kerneldir
}

PACKAGES =+ "kernel-dbg"
FILES_kernel-dbg += "${KERNEL_SRC_PATH}/.debug/vmlinux \
                     ${KERNEL_SRC_PATH}/scripts/.debug \
                     ${KERNEL_SRC_PATH}/scripts/*/.debug \
                     /usr/src/debug \
"
