require recipes-core/images/mel-image.inc

SUMMARY = "A development/debugging image that fully supports the target \
device hardware."

IMAGE_FEATURES_DEVELOPMENT ?= "debug-tweaks tools-profile"
IMAGE_FEATURES = "${IMAGE_FEATURES_DEVELOPMENT}"
IMAGE_FEATURES_DISABLED_DEVELOPMENT ?= ""
IMAGE_FEATURES_remove = "${IMAGE_FEATURES_DISABLED_DEVELOPMENT}"
