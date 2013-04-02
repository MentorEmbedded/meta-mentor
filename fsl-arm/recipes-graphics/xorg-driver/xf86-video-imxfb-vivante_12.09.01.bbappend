PR .= ".1"

LDFLAGS := "${@oe_filter_out('-l', LDFLAGS, d)}"
