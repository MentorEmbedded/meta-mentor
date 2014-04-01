# Use PACKAGECONFIG handling for rdepends
RDEPENDS_${PN} = "dbus xuser-account"
PACKAGECONFIG[bluetooth] .= ",bluez4"
PACKAGECONFIG[3g] .= ",ofono"
PACKAGECONFIG[wifi] .= ",wpa-supplicant"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://fix-stoping-interfaces-at-start.patch \
            file://connman.service \
            "
do_install_append() {
    cp -f ${WORKDIR}/connman.service ${D}${systemd_unitdir}/system/
}
