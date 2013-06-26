PACKAGECONFIG ?= "gnutls"
PACKAGECONFIG_class-native ?= "openssl"
PACKAGECONFIG_class-nativesdk ?= ""

PACKAGECONFIG[openssl] = "--with-ssl,--without-ssl,openssl,"
PACKAGECONFIG[gnutls] = "--with-gnutls=${STAGING_LIBDIR}/../,--without-gnutls,gnutls,"

DEPENDS := "${@oe_filter_out('gnutls$', DEPENDS, d)}"
DEPENDS_class-native := "${@oe_filter_out('openssl-native$', d.getVar('DEPENDS_class-native', True), d)}"

CURLGNUTLS = ""
CURLGNUTLS_class-native = ""
CURLGNUTLS_class-nativesdk = ""
