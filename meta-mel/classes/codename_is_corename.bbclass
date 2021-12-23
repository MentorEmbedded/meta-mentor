# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

python codename_is_corename() {
    codename = d.getVar('DISTRO_CODENAME')
    if codename:
        corenames = d.getVar('LAYERSERIES_CORENAMES')
        if corenames and codename not in corenames.split():
            raise_sanity_error("This version of %s is incompatible with this version of openembedded-core (code name %s). Please use matching layer branches or update %s." % (d.getVar('DISTRO'), d.getVar('LAYERSERIES_CORENAMES'), d.getVar('DISTRO_NAME') or d.getVar('DISTRO')), d, network_error=False)
}
codename_is_corename[eventmask] = 'bb.event.SanityCheck'
addhandler codename_is_corename
