python () {
    if 'mel' in d.getVar('OVERRIDES', True).split(':'):
        d.setVarFlag('PACKAGECONFIG', 'bluetooth', d.getVarFlag('PACKAGECONFIG', 'bluetooth', True).replace('bluez4', '${VIRTUAL-RUNTIME_bluetooth-stack}'))
}
