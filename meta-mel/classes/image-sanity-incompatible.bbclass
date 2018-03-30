# Add an image QA check which fails if any packages were installed which have
# incompatible licenses, with a variable to control whether whitelisted
# recipes/packages are allowed in the image.
#
# Usage: add to IMAGE_CLASSES or inherit directly in an image recpe.
#
# This acts both as a final sanity check to make sure incompatibly
# licensed packages don't end up in the image (though they shouldn't
# unless whitelisted already), and a way to create images which never
# allow gplv3 packages and others which do, i.e. production vs
# development.

ALLOW_ALL_INCOMPATIBLE_WHITELISTED ?= "1"
ALLOWED_INCOMPATIBLE_WHITELISTED ?= ""

IMAGE_INCOMPATIBLE_MESSAGE = "Packages with incompatible licenses were installed: \
%s. See INCOMPATIBLE_LICENSE. To allow this, either set ALLOW_ALL_INCOMPATIBLE_WHITELISTED \
to 1 or add the packages to ALLOWED_INCOMPATIBLE_WHITELISTED"

IMAGE_QA_COMMANDS += "image_check_incompatible_packages"
python image_check_incompatible_packages () {
    import oe.license
    import oe.packagedata
    manifest = d.getVar('IMAGE_MANIFEST')
    pkgnames = []
    with open(manifest, 'r') as f:
        for l in f.readlines():
            pkgnames.append(l.split()[0])

    bad_licenses = (d.getVar('INCOMPATIBLE_LICENSE') or '').split()
    if not bad_licenses:
        return

    bad_licenses = [canonical_license(d, l) for l in bad_licenses]
    bad_licenses = expand_wildcard_licenses(d, bad_licenses)

    whitelist = []
    for lic in bad_licenses:
        spdx_license = return_spdx(d, lic)
        for w in ["LGPLv2_WHITELIST_", "WHITELIST_"]:
            whitelist.extend((d.getVar(w + lic) or "").split())
            if spdx_license:
                whitelist.extend((d.getVar(w + spdx_license) or "").split())

    allow_all_whitelisted = bb.utils.to_boolean(d.getVar('ALLOW_ALL_INCOMPATIBLE_WHITELISTED'))
    allowed_whitelisted = d.getVar('ALLOWED_INCOMPATIBLE_WHITELISTED').split()

    incompatible_packages = []
    pkgdatadir = d.getVar('PKGDATA_DIR')
    for pkgname in sorted(pkgnames):
        pkginfo = os.path.join(pkgdatadir, 'runtime', pkgname)
        pkginfor = os.path.join(pkgdatadir, 'runtime-reverse', pkgname)
        pkgdata = oe.packagedata.read_pkgdatafile(pkginfor)
        pkgdata.update(oe.packagedata.read_pkgdatafile(pkginfo))

        pn = pkgdata['PN']
        if (pn in whitelist and
                (allow_all_whitelisted or pn in allowed_whitelisted)):
            # License is irrelevent if it'll be allowed anyway, skip
            continue

        for k, v in pkgdata.items():
            if k.startswith('PKG_') and v == pkgname:
                # Renamed (i.e. debian.bbclass), get the original name
                pkgname = k[4:]

        if 'LICENSE' not in pkgdata and 'LICENSE_' + pkgname in pkgdata:
            pkgdata['LICENSE'] = pkgdata['LICENSE_' + pkgname]
        license = pkgdata['LICENSE']

        l = d.createCopy()
        l.setVar('LICENSE', license)
        if incompatible_license(l, bad_licenses):
            incompatible_packages.append(pkgname)

    if incompatible_packages:
        message = d.getVar('IMAGE_INCOMPATIBLE_MESSAGE')
        raise oe.utils.ImageQAFailed(message % ' '.join(incompatible_packages), 'image_check_incompatible_packages')
}
