SUMMARY = "A production image that fully supports the target device \
hardware."

IMAGE_FEATURES_PRODUCTION ?= ""
IMAGE_FEATURES = "${IMAGE_FEATURES_PRODUCTION} ${EXTRA_IMAGE_FEATURES}"
IMAGE_FEATURES_DISABLED_PRODUCTION ?= "debug-tweaks codebench-debug tools-profile"
IMAGE_FEATURES:remove = "${IMAGE_FEATURES_DISABLED_PRODUCTION}"

require recipes-core/images/mel-image.inc
