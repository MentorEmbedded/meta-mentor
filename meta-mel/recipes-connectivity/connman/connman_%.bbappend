BT_PKGCONF = ""
BT_PKGCONF_mel = "--enable-bluetooth,--disable-bluetooth,,${VIRTUAL-RUNTIME_bluetooth-stack}"

python () {
    """While this is rather indirect, it's better to leverage OVERRIDES than to
    directly check DISTRO/DISTROOVERRIDES ourselves."""
    bt_pkgconf = d.getVar('BT_PKGCONF', True)
    if bt_pkgconf:
        d.setVarFlag('PACKAGECONFIG', 'bluetooth', d.getVar('BT_PKGCONF', False))
}

# do not use connman as a DNs
# proxy because both dnsmasq and connman try to bind to same port 53.
do_install_append_mel () {
    sed -i '/^ExecStart=/ s@-n@--nodnsproxy -n@g' ${D}${systemd_unitdir}/system/connman.service
}

