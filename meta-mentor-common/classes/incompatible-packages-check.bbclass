# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

def any_incompatible(d, packages, licensestring=None):
    """Return True if any of the specified packages are skipped due to incompatible license.
    
    The user may specify the package's license for cross-recipe checks.
    """
    bad_licenses = (d.getVar('INCOMPATIBLE_LICENSE') or "").split()
    if not bad_licenses:
        return False
    bad_licenses = expand_wildcard_licenses(d, bad_licenses)

    if licensestring is None:
        licensestring = d.getVar("LICENSE:%s" % package) if package else None
        if not licensestring:
            licensestring = d.getVar('LICENSE')

    exceptions = (d.getVar("INCOMPATIBLE_LICENSE_EXCEPTIONS") or "").split()
    for pkg in packages:
        remaining_bad_licenses = oe.license.apply_pkg_license_exception(pkg, bad_licenses, exceptions)

        incompatible_lic = incompatible_pkg_license(d, remaining_bad_licenses, licensestring)
        if incompatible_lic:
            return True
    return False
