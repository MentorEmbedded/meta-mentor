DEPENDS := "${@oe_filter_out('gtk\+$', '${DEPENDS}', d)}"

PACKAGECONFIG ?= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gui', '', d)}"
PACKAGECONFIG[gui] = ",,gtk+"

EXTRA_OEMAKE_X = "${@bb.utils.contains('PACKAGECONFIG', 'gui', 'HAS_GTK_GUI=1', '', d)}"
