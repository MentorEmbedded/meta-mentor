python () {
    inst = d.getVar('do_install', False)
    inst = inst.replace('if [ "$libdir" != "/usr/lib" ]; then',
                        'if [ "$libdir" != "/usr/lib" ] && [ -e "${D}/usr/lib" ]; then')
    d.setVar('do_install', inst)
}
