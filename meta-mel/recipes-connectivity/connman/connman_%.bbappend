BT_PKGCONF = ""
BT_PKGCONF_mel = "--enable-bluetooth,--disable-bluetooth,,${VIRTUAL-RUNTIME_bluetooth-stack}"

python () {
    """While this is rather indirect, it's better to leverage OVERRIDES than to
    directly check DISTRO/DISTROOVERRIDES ourselves."""
    bt_pkgconf = d.getVar('BT_PKGCONF', True)
    if bt_pkgconf:
        d.setVarFlag('PACKAGECONFIG', 'bluetooth', d.getVar('BT_PKGCONF', False))
}
