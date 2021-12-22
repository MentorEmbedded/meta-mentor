# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

def save_layerdirs(d):
    for layerpath in d.getVar('BBLAYERS', True).split():
        layerconf = os.path.join(layerpath, 'conf', 'layer.conf')

        l = bb.data.init()
        l.setVar('LAYERDIR', layerpath)
        l = bb.parse.handle(layerconf, l)
        l.expandVarref('LAYERDIR')

        for layername in (l.getVar('BBFILE_COLLECTIONS', True) or '').split():
            d.setVar('LAYERDIR_%s' % layername, layerpath)

python cfg_save_layerdirs () {
    save_layerdirs(d)
}
cfg_save_layerdirs[eventmask] = "bb.event.ConfigParsed"
addhandler cfg_save_layerdirs
