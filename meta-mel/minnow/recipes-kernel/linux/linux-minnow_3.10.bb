inherit kernel cml1-config kernel-config-lttng kernel-config-systemd

COMPATIBLE_MACHINE = "minnow"
DEFAULT_PREFERENCE = "1"

DEPENDS += "lzop-native bc-native"

OVERRIDES .= "${@':minnow-rt' if '${RT_KERNEL_MINNOW}' == 'yes' else ''}"

KERNEL_NAME = "linux-yocto-minnow"
KERNEL_NAME_minnow-rt = "linux-yocto-preempt-rt-minnow"
KVERSION = "3.10.33-2596-g1c96dd8"
KVERSION_minnow-rt = "3.10.35-3000-g4d20502"
KERNEL_SRC_NAME ?= "${KERNEL_NAME}-${KVERSION}"

SRC_URI = "\
    http://s3.amazonaws.com/portal.mentor.com/sources/ATP-2014.05/${KERNEL_SRC_NAME}.tar.xz;name=${KERNEL_NAME} \
    file://defconfig \
"
SRC_URI[linux-yocto-minnow.md5sum] = "756ef78e8dce78dee0caae22433a6602"
SRC_URI[linux-yocto-minnow.sha256sum] = "ae066a56fad013f59c71de235af48da53aa44479ef88819ee50f440e298ea140"
SRC_URI[linux-yocto-preempt-rt-minnow.md5sum] = "431e8beef1354cde7ec6d17bf2880f5a"
SRC_URI[linux-yocto-preempt-rt-minnow.sha256sum] = "feeadc4d5b1a8ab7a1aee3bd99d39c7516a36aa810c361eec9253a8264107352"

PV = "3.10.33+git2596-1c96dd8"
PV_minnow-rt = "3.10.35+git3000-4d20502"

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
