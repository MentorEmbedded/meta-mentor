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
    for layerpath in oe.data.typed_value('BBLAYERS', d):
        layerconf = os.path.join(layerpath, 'conf', 'layer.conf')

        l = bb.data.init()
        l.setVar('LAYERDIR', layerpath)
        l = bb.parse.handle(layerconf, l)
        l.expandVarref('LAYERDIR')

        for layername in l.getVar('BBFILE_COLLECTIONS', True).split():
            d.setVarFlag('LAYERPATHS', layername, layerpath)
            d.setVarFlag('BBFILE_PATTERNS', layername, l.getVar('BBFILE_PATTERN_%s' % layername, False))
}
define_layerpath_data[eventmask] = "bb.event.ConfigParsed"
addhandler define_layerpath_data

RECIPE_LAYERNAME = "${@get_file_layer(FILE, d)}"
RECIPE_LAYERPATH = "${@d.getVarFlag('LAYERPATHS', RECIPE_LAYERNAME)}"
