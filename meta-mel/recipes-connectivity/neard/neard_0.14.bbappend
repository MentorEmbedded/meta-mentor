python () {
    if 'mel' in d.getVar('OVERRIDES', True).split(':'):
        rrecs = d.getVar('RRECOMMENDS_neard', False)
        rrecs = rrecs.replace('bluez4', '${VIRTUAL-RUNTIME_bluetooth-stack}')
        d.setVar('RRECOMMENDS_neard', rrecs)
}
