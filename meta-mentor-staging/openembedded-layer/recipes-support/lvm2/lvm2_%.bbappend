inherit incompatible-recipe-check

REMOVE_INCOMPATIBLE_THIN = "${@'thin-provisioning-tools' if is_incompatible(d, ['thin-provisioning-tools'], 'GPL-3.0') else ''}"
PACKAGECONFIG_remove = "${REMOVE_INCOMPATIBLE_THIN}"
