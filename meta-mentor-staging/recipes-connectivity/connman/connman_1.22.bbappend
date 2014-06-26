# Use PACKAGECONFIG handling for rdepends
RDEPENDS_${PN} = "dbus xuser-account"
PACKAGECONFIG[wifi] = "--enable-wifi, --disable-wifi,,wpa-supplicant"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth,,bluez4"
PACKAGECONFIG[3g] = "--enable-ofono, --disable-ofono,,ofono"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SYSTEMD_SERVICE = "connman.service"
