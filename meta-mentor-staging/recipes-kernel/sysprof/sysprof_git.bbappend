FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://gui-argument.patch"

DEPENDS := "${@oe_filter_out('gtk\+|libglade$', '${DEPENDS}', d)}"
DEPENDS += "glib-2.0"

PACKAGECONFIG ?= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gui', '', d)}"
PACKAGECONFIG[gui] = "--enable-gui,--disable-gui,gtk+ libglade"
