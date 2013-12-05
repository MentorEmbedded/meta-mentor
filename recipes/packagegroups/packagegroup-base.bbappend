PRINC := "${@int(PRINC) + 4}"

RDEPENDS_packagegroup-base-vfat += "dosfstools"
RDEPENDS_packagegroup-base-ipv6 += "dhcp-client"

RDEPENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-stack}"
RRECOMMENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-hw-support}"
