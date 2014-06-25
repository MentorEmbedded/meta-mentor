inherit kernel cml1-config kernel-config-lttng kernel-config-systemd

COMPATIBLE_MACHINE = "minnow"
DEFAULT_PREFERENCE = "1"

DEPENDS += "lzop-native bc-native"

SRC_URI = "\
    http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/linux-yocto-minnow-3.10.33-2596-g1c96dd8.tar.xz \
    file://defconfig \
"
PV = "3.10.33+git2596-g1c96dd8"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

S = "${WORKDIR}/linux-yocto-minnow-3.10.33-2596-g1c96dd8"

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
