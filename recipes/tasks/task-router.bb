inherit task

DESCRIPTION = "Task for useful networking tools for a router-type device"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r0"

VIRTUAL-RUNTIME_swan ?= "strongswan"

ALLOW_EMPTY_${PN} = "1"
RDEPENDS_${PN} += "\
    ipsec-tools iproute2 iptables tcp-wrappers rng-tools \
    ppp rp-pppoe \
    ${VIRTUAL-RUNTIME_swan} \
"
