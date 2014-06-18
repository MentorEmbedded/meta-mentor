DESCRIPTION = "Fman microcode binary"
SECTION = "fm-ucode"
LICENSE = "Freescale-EULA"
LIC_FILES_CHKSUM = "file://EULA;md5=60037ccba533a5995e8d1a838d85799c"

PR = "r1"

COMPATIBLE_MACHINE = "(p1023rdb|p2041rdb|p3041ds|p4080ds|p5020ds|p5040ds|p5020ds-64b|p5040ds-64b|b4420qds|b4420qds-64b|b4860qds|b4860qds-64b|t4160qds|t4160qds-64b|t2080qds|t2080qds-64b|t4240qds|t4240qds-64b)"

SRC_URI = "file://fm-ucode.tgz"

S = "${WORKDIR}/${PN}"

ALLOW_EMPTY_${PN} = "1"
do_install () {
        cp -r ${S}/boot ${D}/
}

PACKAGES += "${PN}-image"
FILES_${PN}-image += "/boot"

