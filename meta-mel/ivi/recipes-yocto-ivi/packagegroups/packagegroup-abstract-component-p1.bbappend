RDEPENDS_${PN}_remove_mel = "bluez5 bluez5-obex"
RDEPENDS_${PN}_append_mel = "\
    packagegroup-base-bluetooth \
    ${@base_contains('VIRTUAL-RUNTIME_bluetooth-stack', 'bluez4', 'bluez4-systemd obexd obex-client', '', d)} \
    ${@base_contains('VIRTUAL-RUNTIME_bluetooth-stack', 'bluez5', 'bluez5-obex', '', d)} \
"
