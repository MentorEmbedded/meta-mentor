BBLAYERS[type] = "list"
BBFILE_COLLECTIONS[type] = "list"

def get_file_layer(filename, d):
    """Return the name of the layer a file resides in"""
    import re

    filename = os.path.normpath(filename)
    layernames = oe.data.typed_value('BBFILE_COLLECTIONS', d)
    for layername in layernames:
        pattern = d.getVarFlag('BBFILE_PATTERNS', layername)
        if re.match(pattern, filename):
            return layername

    for layername in layernames:
        layerpath = d.getVarFlag('LAYERPATHS', layername)
        if filename.startswith(layerpath + '/'):
            return layername

def get_layer_rootdir(layerpath, d):
    """Get the layer 'root'"""
    rootdir = (d.getVar('MELDIR', True) or d.getVar('OEDIR', True) or
               d.getVar('OEROOT', True) or
               os.path.dirname(d.getVar('COREBASE', True)))
    if rootdir:
        if layerpath.startswith(rootdir + '/'):
            remainder = layerpath[len(rootdir)+1:].split('/')
            return os.path.join(rootdir, remainder[0])

    return layerpath

python define_layerpath_data() {
    if not isinstance(e, bb.event.ConfigParsed):
        return

    for layerpath in oe.data.typed_value('BBLAYERS', e.data):
        layerconf = os.path.join(layerpath, 'conf', 'layer.conf')

        d = bb.data.init()
        d.setVar('LAYERDIR', layerpath)
        d = bb.parse.handle(layerconf, d)
        d.expandVarref('LAYERDIR')

        for layername in d.getVar('BBFILE_COLLECTIONS', True).split():
            e.data.setVarFlag('LAYERPATHS', layername, layerpath)
            e.data.setVarFlag('BBFILE_PATTERNS', layername, d.getVar('BBFILE_PATTERN_%s' % layername, False))
}
addhandler define_layerpath_data

RECIPE_LAYERNAME = "${@get_file_layer(FILE, d)}"
RECIPE_LAYERPATH = "${@d.getVarFlag('LAYERPATHS', RECIPE_LAYERNAME)}"
