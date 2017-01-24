DESCRIPTION = "Fman microcode binary"
SECTION = "fm-ucode"
LICENSE = "Freescale-EULA"
LIC_FILES_CHKSUM = "file://EULA;md5=60037ccba533a5995e8d1a838d85799c"
LIC_FILES_CHKSUM_t4240rdb-64b = "file://EULA;md5=c9ae442cf1f9dd6c13dfad64b0ffe73f"

PR = "r1"

COMPATIBLE_MACHINE = "(p1023rdb|e500mc|e5500|e5500-64b|e6500|e6500-64b|fsl-lsch2)"

SRC_URI = "file://fm-ucode.tgz"
SRC_URI_t4240rdb-64b = "file://fm-ucode-t4240rdb.tgz"

S = "${WORKDIR}/${PN}"

ALLOW_EMPTY_${PN} = "1"
do_install () {
        cp -r ${S}/boot ${D}/
}

PACKAGES += "${PN}-image"
FILES_${PN}-image += "/boot"

