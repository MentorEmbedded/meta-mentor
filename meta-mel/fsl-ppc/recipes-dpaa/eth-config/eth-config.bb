DESCRIPTION = "Ethernet Configuration Files"
SECTION = "eth-config"
LICENSE = "Freescale-EULA"
LIC_FILES_CHKSUM = "file://COPYING;md5=cf02dc8eb5ac4a76f3812826520dea87"

PR = "r2"

SRC_URI = "file://eth-config.tgz"

S = "${WORKDIR}/${PN}"

do_install() {
        cp -r ${S}/etc ${D}/
}
