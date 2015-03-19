# Use PACKAGECONFIG handling for rdepends
RDEPENDS_${PN} = "dbus xuser-account"
PACKAGECONFIG[wifi] = "--enable-wifi, --disable-wifi,,wpa-supplicant"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth,,bluez5"
PACKAGECONFIG[3g] = "--enable-ofono, --disable-ofono,,ofono"
