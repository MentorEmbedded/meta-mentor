DEPENDS += "libgcrypt"
DEPENDS := "${@oe_filter_out('gnutls|openssl', '${DEPENDS}', d)}"

WPA_SUPPLICANT_TLS_LIB ?= "gnutls"

do_configure_append () {
    sed -i '/CONFIG_TLS/d' wpa_supplicant/.config
    echo "CONFIG_TLS = ${WPA_SUPPLICANT_TLS_LIB}" >>wpa_supplicant/.config
}

