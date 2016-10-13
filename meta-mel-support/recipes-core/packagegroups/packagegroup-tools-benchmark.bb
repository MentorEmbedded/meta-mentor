inherit packagegroup

DESCRIPTION = "Package group for benchmarking the target"
PR = "r0"

RDEPENDS_${PN} += "\
    bonnie++ \
    lmbench \
    iozone3 \
    iperf3 \
    dbench \
    tbench \
    tiobench \
"
