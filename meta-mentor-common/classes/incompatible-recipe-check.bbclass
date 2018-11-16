def is_incompatible(d, recipes, license='GPL-3.0'):
    '''Return True if license is incompatible and none of the specified recipes are whitelisted.'''
    return incompatible_license_contains(license, not any_whitelisted(d, recipes, license), False, d)

def any_whitelisted(d, recipes, license='GPL-3.0'):
    '''Return True if any of the recipes were whitelisted for the specified license.'''
    whitelisted = whitelisted_recipes(d, license)
    return any(recipe in whitelisted for recipe in recipes)

def whitelisted_recipes(d, license):
    '''Return all recipes whitelisted for the given license.'''
    lics = [license]
    for flag, value in d.getVarFlags('SPDXLICENSEMAP').items():
        if value == license:
            lics.append(flag)

    whitelisted = set()
    for lic in lics:
        lic_whitelisted = d.getVar('WHITELIST_' + lic)
        if lic_whitelisted:
            whitelisted |= set(lic_whitelisted.split())
    return whitelisted
