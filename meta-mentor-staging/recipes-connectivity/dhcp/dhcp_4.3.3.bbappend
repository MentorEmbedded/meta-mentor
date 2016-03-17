FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://libxml2-configure-argument.patch"
PACKAGECONFIG[bind-httpstats] = "--with-libxml2,--without-libxml2,libxml2"
