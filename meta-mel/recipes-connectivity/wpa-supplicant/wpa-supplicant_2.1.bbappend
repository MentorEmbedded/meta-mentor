WPA_SUPPLICANT_TLS_LIB ?= "gnutls"
DEPENDS := "${@DEPENDS.replace('openssl', '').replace('gnutls', '${WPA_SUPPLICANT_TLS_LIB}' if 'mel' in OVERRIDES.split(':') else 'gnutls openssl')}"

do_configure_append_mel () {
    sed -i '/CONFIG_TLS/d' wpa_supplicant/.config
    echo "CONFIG_TLS = ${WPA_SUPPLICANT_TLS_LIB}" >>wpa_supplicant/.config
}
