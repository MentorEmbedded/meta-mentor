inherit packagegroup

DESCRIPTION = "Package group for a nas-type device"
PR = "r0"

VIRTUAL-RUNTIME_swan ?= "strongswan"

RDEPENDS_${PN} += "\
    ipsec-tools iproute2 iptables tcp-wrappers rng-tools \
    ppp rp-pppoe \
    ${VIRTUAL-RUNTIME_swan} \
"
