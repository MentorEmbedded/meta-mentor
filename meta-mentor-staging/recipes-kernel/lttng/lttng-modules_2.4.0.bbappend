# Update to latest stable revision
SRCREV = "6edef96ea00a04ae7e19a435a5fe693a23e705c2"
PV = "2.4.1"

# This is part to upstream stable commits, filter out the patch
SRC_URI := "${@oe_filter_out('.*bio-bvec-iter', SRC_URI, d)}"
