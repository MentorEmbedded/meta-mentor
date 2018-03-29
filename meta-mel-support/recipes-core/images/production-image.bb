require recipes-core/images/mel-image.inc

# By default, do not allow incompatibly-licensed packages in the
# production-image, even when whitelisted. ALLOWED_INCOMPATIBLE_WHITELISTED
# may be used to explicitly allow individual packages.
ALLOW_ALL_INCOMPATIBLE_WHITELISTED = "0"

SUMMARY = "A production image that fully supports the target device \
hardware."

IMAGE_FEATURES_PRODUCTION ?= ""
IMAGE_FEATURES = "${IMAGE_FEATURES_PRODUCTION}"
IMAGE_FEATURES_DISABLED_PRODUCTION ?= "debug-tweaks codebench-debug tools-profile"
IMAGE_FEATURES_remove = "${IMAGE_FEATURES_DISABLED_PRODUCTION}"
