# Add support for 'USER_FEATURES', which is a mechanism by which a user can
# exert control over DISTRO_FEATURES from local.conf.
#
# To add a feature, simply add it to USER_FEATURES. To remove a feature, add
# the feature prefixed by ~. For example: USER_FEATURES += "bluetooth"

USER_FEATURES ?= ""
USER_FEATURES[type] = "list"

python process_user_features () {
    if not isinstance(e, bb.event.ConfigParsed):
        return

    l = e.data.createCopy()
    l.finalize()
    oe_import(l)

    user_features = oe.data.typed_value('USER_FEATURES', l)
    if not user_features:
        return

    to_remove, to_add = set(), set()
    for feature in user_features:
        if feature.startswith('~'):
            to_remove.add(feature[1:])
        else:
            to_add.add(feature)

    distro_features = l.getVar('DISTRO_FEATURES', True).split()
    distro_features = filter(lambda f: f not in to_remove, distro_features)
    distro_features.extend(to_add)
    e.data.setVar('DISTRO_FEATURES', ' '.join(distro_features))
}
addhandler process_user_features
