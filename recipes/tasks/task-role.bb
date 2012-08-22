inherit task

DESCRIPTION = "Tasks for fulfilling common roles for the target (e.g. nas, router)"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r0"

VIRTUAL-RUNTIME_swan ?= "strongswan"

PACKAGES = "\
    task-role-router \
    task-role-print-server \
    task-role-nas \
"

ALLOW_EMPTY_task-role-router = "1"
RDEPENDS_task-role-router += "\
    ipsec-tools iproute2 iptables tcp-wrappers rng-tools \
    ppp rp-pppoe \
    ${VIRTUAL-RUNTIME_swan} \
"

ALLOW_EMPTY_task-role-print-server = "1"
RDEPENDS_task-role-print-server += "\
    samba \
    swat \
"

ALLOW_EMPTY_task-role-nas = "1"
RDEPENDS_task-role-nas += "\
    samba \
    swat \
    tzdata \
    task-core-nfs-server \
"
