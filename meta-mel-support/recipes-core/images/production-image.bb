# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SUMMARY = "A production image that fully supports the target device \
hardware."

# By default, do not allow incompatibly-licensed packages in the
# production-image, even when whitelisted. ALLOWED_INCOMPATIBLE_WHITELISTED
# may be used to explicitly allow individual packages.
ALLOW_ALL_INCOMPATIBLE_WHITELISTED = "0"

IMAGE_FEATURES_PRODUCTION ?= ""
IMAGE_FEATURES = "${IMAGE_FEATURES_PRODUCTION} ${EXTRA_IMAGE_FEATURES}"
IMAGE_FEATURES_DISABLED_PRODUCTION ?= "debug-tweaks codebench-debug tools-profile"
IMAGE_FEATURES:remove = "${IMAGE_FEATURES_DISABLED_PRODUCTION}"

require recipes-core/images/mel-image.inc
