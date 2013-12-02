DEPENDS_class-nativesdk += "nativesdk-openssl"
CURLGNUTLS_class-nativesdk += "--without-gnutls --with-ssl"

#EXTRA_OECONF += "--with-ca-path=${sysconfdir}/ssl/certs"
EXTRA_OECONF += "--with-ca-bundle=${sysconfdir}/ssl/certs/ca-certificates.crt"

RRECOMMENDS_${PN} += "ca-certificates"
