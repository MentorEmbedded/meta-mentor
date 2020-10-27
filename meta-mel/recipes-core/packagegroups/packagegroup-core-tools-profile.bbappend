inherit incompatible-recipe-check

PROFILE_TOOLS_X_remove = "${@'sysprof' if is_incompatible(d, ['sysprof'], 'GPL-3.0') else ''}"

# MEL Flex does not support systemtap. Systemtap brings boost which takes lots of resources. So we do not need it.
SYSTEMTAP_mel = ""
