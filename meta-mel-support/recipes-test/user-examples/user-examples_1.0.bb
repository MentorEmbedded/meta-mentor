LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://sh-test-lib \
          "

S = "${WORKDIR}"

do_install() {
        install -d ${D}${datadir}/examples/
        install -m 0777 ${S}/sh-test-lib ${D}${datadir}/examples/
}

FILES_${PN} += "${datadir}/examples"
