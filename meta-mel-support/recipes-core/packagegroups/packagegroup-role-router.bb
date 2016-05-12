inherit packagegroup

DESCRIPTION = "Package group for a router-type device"
PR = "r0"

RDEPENDS_${PN} += "\
    samba \
    swat \
    tzdata \
    packagegroup-core-nfs-server \
"
