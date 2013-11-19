# Emitting a binary package that depends on all the others doesn't make sense
# here, as all the packages aren't always emitted.
PACKAGES := "${@oe_filter_out('${PN}-drivers', PACKAGES, d)}"
