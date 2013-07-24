PACKAGECONFIG ??= "\
    xz \
    tcp-wrappers \
    sysvcompat \
"

EXTRA_OECONF := "${@oe_filter_out('--with-sysvrcnd', EXTRA_OECONF, d)}"
PACKAGECONFIG[sysvcompat] = "--with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"
