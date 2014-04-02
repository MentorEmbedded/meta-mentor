# Deploy the downloads necessary for doing offline builds with the layers
# distributed by archive-release, taking into account redistribution rights
# for those sources by using license filtering.
#
# Originally copied from copyleft_compliance. This is kept separate due to the
# slightly different purposes, and to let us alter how it operates without
# affecting potential user use of copyleft_compliance.
#
# vi:sts=4:sw=4:et

ARCHIVE_RELEASE_DL_DIR ?= '${DEPLOY_DIR}/release-downloads'
ARCHIVE_RELEASE_EXCLUDED_DL_DIR ?= '${DEPLOY_DIR}/release-downloads-excluded'

DL_LICENSE_INCLUDE ?= "${@' '.join(sorted(set(d.getVarFlags('SPDXLICENSEMAP').values())))}"
DL_LICENSE_INCLUDE[type] = 'list'
DL_LICENSE_INCLUDE[doc] = 'Space separated list of included licenses (supports wildcards)'

DL_LICENSE_EXCLUDE ?= 'CLOSED Proprietary* Mentor Freescale EULA INTEL NetLogic'
DL_LICENSE_EXCLUDE[type] = 'list'
DL_LICENSE_EXCLUDE[doc] = 'Space separated list of excluded licenses (supports wildcards)'

python do_archive_release_downloads () {
    """Populate a tree of the recipe sources and emit patch series files"""
    import os.path
    import shutil
    import oe.license

    include = oe.data.typed_value('DL_LICENSE_INCLUDE', d)
    exclude = oe.data.typed_value('DL_LICENSE_EXCLUDE', d)

    try:
        included, reason = oe.license.is_included(d.getVar('LICENSE', True), include, exclude)
    except oe.license.LicenseError as exc:
        bb.fatal('%s: %s' % (d.getVar('PF', True), exc))

    p = d.getVar('P', True)
    if not included:
        bb.debug(1, 'archive-release-downloads: %s is excluded: %s' % (p, reason))
        sources_dir = d.getVar('ARCHIVE_RELEASE_EXCLUDED_DL_DIR', True)
    else:
        bb.debug(1, 'archive-release-downloads: %s is included: %s' % (p, reason))
        sources_dir = d.getVar('ARCHIVE_RELEASE_DL_DIR', True)

    dl_dir = d.getVar('DL_DIR', True)
    src_uri = d.getVar('SRC_URI', True).split()
    fetch = bb.fetch2.Fetch(src_uri, d)
    ud = fetch.ud

    bb.utils.mkdirhier(sources_dir)

    for u in ud.values():
        local = fetch.localpath(u.url)
        if local.endswith('.bb'):
            continue
        elif not local.startswith(dl_dir + '/'):
            # For our purposes, we only want downloads, not what's in the layers
            continue
        elif local.endswith('/'):
            local = local[:-1]

        if u.mirrortarball:
            tarball_path = os.path.join(dl_dir, u.mirrortarball)
            if os.path.exists(tarball_path):
                local = tarball_path

        oe.path.symlink(local, os.path.join(sources_dir, os.path.basename(local)), force=True)
}

do_archive_release_downloads[dirs] = "${WORKDIR}"
addtask archive_release_downloads after do_fetch

python do_archive_release_downloads_all() {
    pass
}
do_archive_release_downloads_all[recrdeptask] = "do_archive_release_downloads_all do_archive_release_downloads"
do_archive_release_downloads_all[recideptask] = "do_${BB_DEFAULT_TASK}"
do_archive_release_downloads_all[nostamp] = "1"
addtask archive_release_downloads_all after do_archive_release_downloads
