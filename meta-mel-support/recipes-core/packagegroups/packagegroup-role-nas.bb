inherit packagegroup

DESCRIPTION = "Package group for a nas-type device"
PR = "r0"

VIRTUAL-RUNTIME_swan ?= "strongswan"

RDEPENDS_${PN} += "\
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'networking-layer', 'ipsec-tools rp-pppoe ${VIRTUAL-RUNTIME_swan}', '', d)} \
    iproute2 iptables tcp-wrappers rng-tools \
    ppp \
"
