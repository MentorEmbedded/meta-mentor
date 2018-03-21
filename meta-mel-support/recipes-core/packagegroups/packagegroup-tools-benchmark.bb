inherit packagegroup incompatible-recipe-check

DESCRIPTION = "Package group for benchmarking the target"
PR = "r0"

RDEPENDS_${PN} += "\
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'lmbench tiobench bonnie++ iozone3 iperf3 dbench', '', d)} \
"

RDEPENDS_${PN}_remove = "${@'dbench' if is_incompatible(d, ['dbench'], 'GPL-3.0') else ''}"
