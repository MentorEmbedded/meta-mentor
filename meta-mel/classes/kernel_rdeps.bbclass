python () {
    name = d.getVar('KERNEL_PACKAGE_NAME')
    for pkg in [name + '-base', name + '-image']:
        rdeps = d.getVar('RDEPENDS_%s' % pkg, False)
        if rdeps and rdeps.strip():
            bb.debug(1, 'Converted rdeps to rrecs for %s: %s' % (pkg, rdeps))
            d.setVar('RDEPENDS_%s' % pkg, '')
            d.appendVar('RRECOMMENDS_%s' % pkg, ' ' + rdeps)
}
