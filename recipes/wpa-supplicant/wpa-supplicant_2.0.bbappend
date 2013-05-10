PR .= ".1"

WPA_SUPPLICANT_TLS_LIB ?= "gnutls"
DEPENDS := "${@oe_filter_out('gnutls$', DEPENDS, d)}"
DEPENDS += "${WPA_SUPPLICANT_TLS_LIB}"

do_configure_append () {
    sed -i '/CONFIG_TLS/d' wpa_supplicant/.config
    echo "CONFIG_TLS = ${WPA_SUPPLICANT_TLS_LIB}" >>wpa_supplicant/.config
}
