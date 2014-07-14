WPA_SUPPLICANT_TLS_LIB ?= "gnutls"

do_configure_append_mel () {
    sed -i '/CONFIG_TLS/d' wpa_supplicant/.config
    echo "CONFIG_TLS = ${WPA_SUPPLICANT_TLS_LIB}" >>wpa_supplicant/.config
}

python () {
    if 'mel' in d.getVar('OVERRIDES', True).split(':'):
        depends = d.getVar('DEPENDS', False)
        depends = depends.replace('openssl', '').replace('gnutls', '${WPA_SUPPLICANT_TLS_LIB}')
        d.setVar('DEPENDS', depends)
}
