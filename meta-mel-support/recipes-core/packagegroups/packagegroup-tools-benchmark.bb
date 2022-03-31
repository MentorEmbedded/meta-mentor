inherit packagegroup

DESCRIPTION = "Package group for benchmarking the target"
PR = "r0"

META_OE_BENCHMARKS = "\
    bonnie++ \
    dbench \
    iozone3 \
    iperf3 \
    lmbench \
    tiobench \
"

RDEPENDS:${PN} += "\
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', d.getVar('META_OE_BENCHMARKS'), '', d)} \
"
