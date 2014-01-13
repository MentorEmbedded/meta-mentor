PACKAGECONFIG[defaultval] .= "${@' sysvcompat' if 'mel' in OVERRIDES.split(':') else ''}"

EXTRA_OECONF := "${@oe_filter_out('--with-sysvrcnd=${sysconfdir}' if 'mel' in OVERRIDES.split(':') else '', EXTRA_OECONF, d)}"
PACKAGECONFIG[sysvcompat] = "--with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"
