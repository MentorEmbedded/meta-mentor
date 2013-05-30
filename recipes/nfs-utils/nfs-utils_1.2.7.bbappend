DEPENDS := "${@oe_filter_out('tcp-wrappers', DEPENDS, d)}"
PACKAGECONFIG[tcp-wrappers] = "--with-tcp-wrappers,--without-tcp-wrappers,tcp-wrappers"
