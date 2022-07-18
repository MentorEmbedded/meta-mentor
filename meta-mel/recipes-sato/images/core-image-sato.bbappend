# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

IMAGE_FEATURES:append:mel = "${@bb.utils.contains('COMBINED_FEATURES', 'alsa', ' tools-audio', '', d)}"
IMAGE_INSTALL:append:mel = " quota"
