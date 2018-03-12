inherit packagegroup

DESCRIPTION = "Package group for a router-type device"
PR = "r0"

RDEPENDS_${PN} += "\
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'samba', '', d)} \
    tzdata \
    packagegroup-core-nfs-server \
"
