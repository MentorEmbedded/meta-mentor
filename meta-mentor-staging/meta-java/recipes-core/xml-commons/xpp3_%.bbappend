python () {
    func = d.getVar('do_compile', False)
    func = func.replace('${sourcepath//:/ }', '$(echo "$sourcepath" | tr : " ")')
    d.setVar('do_compile', func)
}
