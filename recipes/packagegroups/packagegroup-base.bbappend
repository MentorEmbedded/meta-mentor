PRINC := "${@int(PRINC) + 4}"

RDEPENDS_packagegroup-base-vfat += "dosfstools"
RDEPENDS_packagegroup-base-ipv6 += "dhcp-client"
