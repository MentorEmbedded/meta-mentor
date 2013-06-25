PR .= ".3"

DEPENDS := "${@oe_filter_out('nautilus', DEPENDS, d)}"
PACKAGECONFIG ??= "nautilus"
PACKAGECONFIG[nautilus] = "--enable-nautilus-extension,--disable-nautilus-extension,nautilus"
