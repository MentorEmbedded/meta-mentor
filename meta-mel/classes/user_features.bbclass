# Add support for 'USER_FEATURES', which is a mechanism by which a user can
# exert control over DISTRO_FEATURES from local.conf. At this point it's just
# a convenience wrapper around _append and _remove.
#
# To add a feature, simply add it to USER_FEATURES. To remove a feature, add
# the feature prefixed by ~. For example: USER_FEATURES += "bluetooth"

USER_FEATURES ?= ""
USER_FEATURES[type] = "list"
USER_FEATURES_HANDLED_VARS = "DISTRO_FEATURES_LIBC DISTRO_FEATURES"
USER_FEATURES_HANDLED_VARS[type] = "list"

python process_user_features () {
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

    # If a feature we want to add is listed in the _DEFAULT variable, then we
    # know which variable it belongs in, so add it there rather than
    # DISTRO_FEATURES. Also remove from all the vars, not just
    # DISTRO_FEATURES.
    for var in oe.data.typed_value('USER_FEATURES_HANDLED_VARS', l):
        defvar = var + '_DEFAULT'
        if to_add and defvar in l:
            defvalue = set((l.getVar(defvar, True) or '').split())
            to_add_here = set(a for a in to_add if a in defvalue)
            to_add -= to_add_here
            e.data.appendVar(var, ' ' + ' '.join(to_add_here))

        e.data.setVar(var + '_remove', ' '.join(to_remove))

    if to_add:
        e.data.appendVar('DISTRO_FEATURES', ' ' + ' '.join(to_add))
}
process_user_features[eventmask] = "bb.event.ConfigParsed"
addhandler process_user_features
