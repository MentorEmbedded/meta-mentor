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

    distro_features = l.getVar('DISTRO_FEATURES', True).split()
    for feature in user_features:
        if feature.startswith('~'):
            feature = feature[1:]
            if feature in distro_features:
                distro_features.remove(feature)
        else:
            if feature not in distro_features:
                distro_features.append(feature)
    e.data.setVar('DISTRO_FEATURES', ' '.join(distro_features))
}
addhandler process_user_features
