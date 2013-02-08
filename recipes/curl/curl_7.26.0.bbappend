PR .= ".1"

PACKAGECONFIG ?= "gnutls"
PACKAGECONFIG_virtclass-native ?= "openssl"
PACKAGECONFIG_virtclass-nativesdk ?= ""

PACKAGECONFIG[openssl] = "--with-ssl,--without-ssl,openssl,"
PACKAGECONFIG[gnutls] = "--with-gnutls=${STAGING_LIBDIR}/../,--without-gnutls,gnutls,"

DEPENDS := "${@oe_filter_out('gnutls$', DEPENDS, d)}"
DEPENDS_virtclass-native := "${@oe_filter_out('openssl-native$', d.getVar('DEPENDS_virtclass-native', True), d)}"

CURLGNUTLS = ""
CURLGNUTLS_virtclass-native = ""
CURLGNUTLS_virtclass-nativesdk = ""
