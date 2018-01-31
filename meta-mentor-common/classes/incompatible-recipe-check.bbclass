def is_incompatible(d, recipes, license='GPL-3.0'):
    '''Return True if license is incompatible and none of the specified recipes are whitelisted.'''
    return incompatible_license_contains(license, not any_whitelisted(d, recipes, license), False, d)

def any_whitelisted(d, recipes, license='GPL-3.0'):
    '''Return True if any of the recipes were whitelisted for the specified license.'''
    lics = [license]
    for flag, value in d.getVarFlags('SPDXLICENSEMAP').items():
        if value == license:
            lics.append(flag)

    for lic in lics:
        whitelisted = (d.getVar('WHITELIST_' + lic, True) or '').split()
        if any(recipe in whitelisted for recipe in recipes):
            return True
    return False
