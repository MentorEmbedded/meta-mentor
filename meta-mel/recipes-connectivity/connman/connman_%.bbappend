# Use PACKAGECONFIG handling for rdepends
RDEPENDS_${PN} = "dbus xuser-account"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth,,${VIRTUAL-RUNTIME_bluetooth-stack}"
