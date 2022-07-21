# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SUMMARY = "MEL DM-Crypt Image initramfs init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

DEPENDS = "virtual/kernel"
RDEPENDS:${PN} += "cryptsetup"
RDEPENDS:${PN} += "lvm2"
RDEPENDS:${PN} += "lvm2-udevrules"
RDEPENDS:${PN} += "udev"

PR = "r0"

SRC_URI = "file://init.sh"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/init.sh ${D}/init
        install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

FILES:${PN} += "/init /dev"

# Due to kernel dependency
PACKAGE_ARCH = "${MACHINE_ARCH}"
