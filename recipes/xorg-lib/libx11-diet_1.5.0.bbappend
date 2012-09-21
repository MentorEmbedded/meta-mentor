PR .= ".1"
RPROVIDES_${PN} += "libx11"
EXTRA_OECONF += "--disable-selective-werror"
EXTRA_OEMAKE += "'CWARNFLAGS='"
