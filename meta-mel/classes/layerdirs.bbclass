python save_layerdirs() {
    for layerpath in d.getVar('BBLAYERS', True).split():
        layerconf = os.path.join(layerpath, 'conf', 'layer.conf')

        l = bb.data.init()
        l.setVar('LAYERDIR', layerpath)
        l = bb.parse.handle(layerconf, l)
        l.expandVarref('LAYERDIR')

        for layername in l.getVar('BBFILE_COLLECTIONS', True).split():
            d.setVar('LAYERDIR_%s' % layername, layerpath)
}
save_layerdirs[eventmask] = "bb.event.ConfigParsed"
addhandler save_layerdirs
