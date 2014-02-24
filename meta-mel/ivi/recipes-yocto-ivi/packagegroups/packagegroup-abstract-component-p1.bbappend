RDEPENDS_${PN}_remove = "bluez4 bluez4-systemd obexd obex-client"
RDEPENDS_${PN} += "packagegroup-base-bluetooth ${VIRTUAL-RUNTIME_bluetooth-stack}"

RDEPENDS_${PN} += "${@base_contains('VIRTUAL-RUNTIME_bluetooth-stack', 'bluez4', 'bluez4-systemd obexd obex-client', '', d)}"
