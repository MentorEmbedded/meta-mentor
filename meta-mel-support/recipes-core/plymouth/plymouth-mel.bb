# Copyright (C) 2016 Mentor Graphics Corporation. All Rights Reserved
# Recipe released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "MEL theme and logo for plymouth"
LICENSE = "Mentor"
LIC_FILES_CHKSUM = ""
INHIBIT_DEFAULT_DEPS = "1"
DEPENDS = ""

SRC_URI = "\
    file://mel.plymouth \
    file://mel.script \
    file://*.png \
"

INSANE_SKIP_${PN} += "already-stripped license-checksum"

do_install () {
    install -d -m 0755 "${D}${datadir}/plymouth/themes/mel"
    install -m 0644 mel.plymouth mel.script *.png "${D}${datadir}/plymouth/themes/mel/"
}
do_install[dirs] = "${WORKDIR}"

FILES_${PN} += "${datadir}/plymouth"
RRECOMMENDS_${PN} += "plymouth"
