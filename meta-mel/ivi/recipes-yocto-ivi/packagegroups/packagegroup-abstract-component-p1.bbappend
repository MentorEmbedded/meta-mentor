RDEPENDS_${PN}_remove = "bluez5 bluez5-obex"
RDEPENDS_${PN} += "packagegroup-base-bluetooth"
RDEPENDS_${PN} += "${@base_contains('VIRTUAL-RUNTIME_bluetooth-stack', 'bluez4', 'bluez4-systemd obexd obex-client', '', d)}"
RDEPENDS_${PN} += "${@base_contains('VIRTUAL-RUNTIME_bluetooth-stack', 'bluez5', 'bluez5-obex', '', d)}"
