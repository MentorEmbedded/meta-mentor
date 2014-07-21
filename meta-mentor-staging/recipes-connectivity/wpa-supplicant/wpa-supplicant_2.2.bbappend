DEPENDS += "libgcrypt"

DEPENDS := "${@oe_filter_out('gnutls|openssl', '${DEPENDS}', d)}"
PACKAGECONFIG[defaultval] += "gnutls"
PACKAGECONFIG[gnutls] = ",,gnutls"
PACKAGECONFIG[ssl] = ",,openssl"

do_configure_append () {
    sed -i '/CONFIG_TLS/d' wpa_supplicant/.config
    if echo "${PACKAGECONFIG}" | grep -qw "ssl"; then
        ssl=openssl
    elif echo "${PACKAGECONFIG}" | grep -qw "gnutls"; then
        ssl=gnutls
    fi
    if [ -n "$ssl" ]; then
        echo "CONFIG_TLS = $ssl" >>wpa_supplicant/.config
    fi
}
