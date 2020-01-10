FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
           file://ble-example.sh \
           "

do_install_append() {
        install -d ${D}${datadir}/examples/ble/
        install -m 0777 ${S}/ble-example.sh ${D}${datadir}/examples/ble/
}
