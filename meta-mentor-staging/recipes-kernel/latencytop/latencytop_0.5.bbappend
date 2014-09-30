DEPENDS := "${@oe_filter_out('gtk+', '${DEPENDS}', d)}"

PACKAGECONFIG ?= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11', '', d)}"
PACKAGECONFIG[x11] = ",,gtk+"

EXTRA_OEMAKE_X = "${@bb.utils.contains('PACKAGECONFIG', 'x11', 'HAS_GTK_GUI=1', '', d)}"
