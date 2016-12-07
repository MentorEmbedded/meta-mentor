inherit incompatible-recipe-check

PROFILE_TOOLS_X_remove = "${@'sysprof' if is_incompatible(d, ['sysprof'], 'GPL-3.0') else ''}"
