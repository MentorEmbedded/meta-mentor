inherit kernel cml1-config kernel-config-lttng kernel-config-systemd

COMPATIBLE_MACHINE = "qemux86$"

DEPENDS += "lzop-native bc-native"

PV = "3.14+git53-0143c6e"
KERNEL_NAME = "linux-yocto-common-pc-base-3.14-53-g0143c6e"

KERNEL_SRC_URI ?= "http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/${KERNEL_NAME}.tar.xz"
SRC_URI = "\
    ${KERNEL_SRC_URI} \
    file://defconfig \
"
SRC_URI[md5sum] = "deec98238905cc61dd05c86de18b81bf"
SRC_URI[sha256sum] = "72437cc89c0fef5033640896185108e8d3e7c34544535dc20e20517f3c12e445"
S = "${WORKDIR}/${KERNEL_NAME}"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

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
