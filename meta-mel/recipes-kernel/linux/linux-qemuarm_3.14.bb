inherit kernel cml1-config kernel-config-lttng kernel-config-systemd

COMPATIBLE_MACHINE = "qemuarm$"

DEPENDS += "lzop-native bc-native"

PV = "3.14+git60-c966987"
KERNEL_NAME = "linux-yocto-arm-versatile-926ejs-3.14-60-gc966987"

KERNEL_SRC_URI ?= "http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/${KERNEL_NAME}.tar.xz"
SRC_URI = "\
    ${KERNEL_SRC_URI} \
    file://defconfig \
"
SRC_URI[md5sum] = "bb2dcd7c1d8d0fb7dbea21e12794fddf"
SRC_URI[sha256sum] = "0872e4495fe522da3a74219738ba6e3f7ac1d5f2fed44b968b54ce96a675b0dc"
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
