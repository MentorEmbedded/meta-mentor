VIRTUAL-RUNTIME_bluetooth-stack ?= "bluez4"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth,--disable-bluetooth, virtual/libbluetooth"
DEPENDS_remove = "bluez4"

RDEPENDS_${PN} = "\
        dbus \
        ${@base_contains('PACKAGECONFIG', 'bluetooth', '${VIRTUAL-RUNTIME_bluetooth-stack}', '', d)} \
        ${@base_contains('PACKAGECONFIG', 'wifi','wpa-supplicant', '', d)} \
        ${@base_contains('PACKAGECONFIG', '3g','ofono', '', d)} \
        xuser-account \
	"
