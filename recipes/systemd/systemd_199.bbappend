DEPENDS := "${@oe_filter_out('tcp-wrappers', DEPENDS, d)}"
PACKAGECONFIG[tcp-wrappers] = "--enable-tcpwrap,--disable-tcpwrap,tcp-wrappers"
