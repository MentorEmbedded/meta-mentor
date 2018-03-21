inherit packagegroup

DESCRIPTION = "Package group for a print-server-type device"
PR = "r0"

RDEPENDS_${PN} += "\
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'samba', '', d)} \
"
