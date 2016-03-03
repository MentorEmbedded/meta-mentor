# rdp-compositor depends on freerdp
DEPENDS_cyclone5 += "freerdp"

# Enable building of rdp-compositor
EXTRA_OECONF_cyclone5 := "${@oe_filter_out('--disable-rdp-compositor', '${EXTRA_OECONF}', d)}"
EXTRA_OECONF_cyclone5 += "--enable-rdp-compositor"
