python add_binprefix () {
    for cclass in ['fontcache', 'pixbufcache']:
        if bb.data.inherits_class(cclass, d):
            common = d.getVar(cclass + '_common', False)
            common = common.replace('mlprefix=${MLPREFIX}', 'mlprefix=${MLPREFIX} binprefix=${MLPREFIX}')
            d.setVar(cclass + '_common', common)
}
add_binprefix[eventmask] = "bb.event.RecipeParsed"
addhandler add_binprefix
