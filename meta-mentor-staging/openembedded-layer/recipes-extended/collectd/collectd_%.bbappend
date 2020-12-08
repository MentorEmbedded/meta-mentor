python () {
    if 'feature-mentor-staging' in d.getVar('OVERRIDES').split(':'):
        for feature in ['rrdtool', 'rrdcached']:
            d.setVarFlag('PACKAGECONFIG', feature, '--enable-{0},--disable-{0},{0}'.format(feature))
}
