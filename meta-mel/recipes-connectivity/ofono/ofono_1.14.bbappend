python () {
    if 'mel' in d.getVar('OVERRIDES', True).split(':'):
        depends = d.getVar('DEPENDS', False)
        depends = depends.replace('bluez4', 'virtual/libbluetooth').replace('bluez5', 'virtual/libbluetooth')
        d.setVar('DEPENDS', depends)
}
