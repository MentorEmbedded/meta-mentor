inherit packagegroup

DESCRIPTION = "Package group for a print-server-type device"
PR = "r0"

RDEPENDS_${PN} += "\
    samba \
"
