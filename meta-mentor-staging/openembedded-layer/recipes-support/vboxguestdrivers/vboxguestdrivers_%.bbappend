python () {
    func = d.getVar('do_compile', False)
    func = func.replace('oe_runmake -C ${S}/utils',
                        "oe_runmake 'LD=${CC}' 'LDFLAGS=${LDFLAGS}' -C ${S}/utils")
    d.setVar('do_compile', func)
}
