FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-connman-implement-network-interface-management-techn.patch \
            file://fix-resolv-link.patch"

RDEPENDS_${PN} += "rng-tools"

INITSCRIPT_PARAMS = "start 95 5 2 3 . stop 22 0 1 6 ."
