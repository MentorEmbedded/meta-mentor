FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://add-polkit-configure-argument.patch"
PACKAGECONFIG[polkit] = "--with-polkit,--without-polkit,polkit,"

# For glib-gettextize
DEPENDS += "glib-2.0-native"
