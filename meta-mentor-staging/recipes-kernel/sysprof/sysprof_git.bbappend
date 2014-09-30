DEPENDS := "${@oe_filter_out('gtk\+|libglade', '${DEPENDS}', d)}"


PACKAGECONFIG ?= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11', '', d)}"
PACKAGECONFIG[x11] = ",,gtk+ libglade"

