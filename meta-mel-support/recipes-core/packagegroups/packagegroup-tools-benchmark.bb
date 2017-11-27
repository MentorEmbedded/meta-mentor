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

RDEPENDS_${PN}_remove = "${@'dbench' if is_incompatible(d, ['dbench'], 'GPL-3.0') else ''}"
RDEPENDS_${PN}_remove = "${@'tbench' if is_incompatible(d, ['tbench'], 'GPL-3.0') else ''}"
