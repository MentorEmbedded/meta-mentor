# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# If any of these layers are available, but not included in BBLAYERS, warn
UPDATES_CHECK_LAYERS ?= "\
    ${MELDIR}/updates/update-*/ \
    ${MELDIR}/update-*/ \
    ${MELDIR}/meta-mentor-cve \
"
UPDATES_CHECK_LAYERS[type] = "list"

check_for_updates () {
    import glob

    layerpaths = []
    for pattern in oe.data.typed_value('UPDATES_CHECK_LAYERS', d):
        layerpaths.extend(glob.glob(pattern))

    if not layerpaths:
        return

    missing = set()
    bblayers = d.getVar('BBLAYERS', True).split()
    bblayers = set(os.path.realpath(p) for p in bblayers)
    for lpath in layerpaths:
        if not os.path.exists(os.path.join(lpath, 'conf', 'layer.conf')):
            continue
        if os.path.realpath(lpath) not in bblayers:
            missing.add(lpath)

    if missing:
        bb.warn("Update layers are available, but not configured. Please add to your bblayers.conf:\n  %s" % '\n  '.join(missing))
}
check_for_updates[eventmask] = "bb.event.ConfigParsed"
addhandler check_for_updates
