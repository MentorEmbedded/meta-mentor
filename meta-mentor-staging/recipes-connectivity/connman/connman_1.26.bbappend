# Use PACKAGECONFIG handling for rdepends
RDEPENDS_${PN} = "dbus xuser-account"
PACKAGECONFIG[wifi] = "--enable-wifi, --disable-wifi,,wpa-supplicant"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth,,bluez5"
PACKAGECONFIG[3g] = "--enable-ofono, --disable-ofono,,ofono"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-connman-implement-network-interface-management-techn.patch"
