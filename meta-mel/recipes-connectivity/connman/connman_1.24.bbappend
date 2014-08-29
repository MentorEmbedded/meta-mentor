python () {
    if 'mel' in d.getVar('OVERRIDES', True).split(':'):
        d.setVarFlag('PACKAGECONFIG', 'bluetooth', d.getVarFlag('PACKAGECONFIG', 'bluetooth', True).replace('bluez4', '${VIRTUAL-RUNTIME_bluetooth-stack}'))
        d.setVar('RDEPENDS_connman', d.getVar('RDEPENDS_connman', True).replace('bluez4', '${PREFERRED_PROVIDER_virtual/libbluetooth}'))
}
