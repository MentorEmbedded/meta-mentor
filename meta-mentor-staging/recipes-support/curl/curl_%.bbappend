#EXTRA_OECONF += "--with-ca-path=${sysconfdir}/ssl/certs"
EXTRA_OECONF += "--with-ca-bundle=${sysconfdir}/ssl/certs/ca-certificates.crt"

RRECOMMENDS_${PN} += "ca-certificates"
