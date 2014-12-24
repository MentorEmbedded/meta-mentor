FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://bind-add-crosscripts-search-path-for-xml2-config.patch \
           "

PACKAGECONFIG = "libxml2"

PACKAGECONFIG[libxml2] = "--with-libxml2=${STAGING_LIBDIR}/..,--with-libxml2=no,libxml2"

inherit pkgconfig
