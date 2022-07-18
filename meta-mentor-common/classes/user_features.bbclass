# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# USER_FEATURES is an explicitly supported mechanism to exert control over
# DISTRO_FEATURES from local.conf without directly poking at it. At this point
# it's just a convenience wrapper around append and remove.
#
# To add a feature, simply add it to USER_FEATURES. To remove a feature, add
# the feature prefixed by ~. For example: USER_FEATURES += "bluetooth"

USER_FEATURES ?= ""
USER_FEATURES_REMOVE ?= "${@' '.join(l[1:] for l in '${USER_FEATURES}'.split() if l.startswith('~'))}"
DISTRO_FEATURES:append = " ${@' '.join(l for l in '${USER_FEATURES}'.split() if not l.startswith('~'))}"
DISTRO_FEATURES:remove = "${USER_FEATURES_REMOVE}"
