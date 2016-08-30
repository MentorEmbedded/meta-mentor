LICENSE_DEFAULT = "GPLv2"
LICENSE = "${LICENSE_DEFAULT} & BSD-2-Clause & GPLv3"

python () {
    for plugin in d.getVar('PLUGINS', True).split():
        if 'LICENSE_%s' % plugin not in d:
            d.setVar('LICENSE_' + plugin, '${LICENSE_DEFAULT}')
}
