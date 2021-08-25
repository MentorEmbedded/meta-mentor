FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += "autoconf-archive"

SRC_URI_append = " \
           file://0001-configure.ac-ax_add_fortify_source.patch \
           file://0002-configure-Use-AX_REQUIRE_DEFINED.patch \
"
