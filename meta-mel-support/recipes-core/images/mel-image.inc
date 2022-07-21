# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# We want a package manager in our base images
IMAGE_FEATURES += "package-management"

# We want libgcc to always be available, even if nothing needs it, as its size
# is minimal, and it's often needed by third party (or QA) binaries
IMAGE_INSTALL:append:mel = " libgcc"

LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES:append:mel = " splash ${@bb.utils.contains('COMBINED_FEATURES', 'alsa', ' tools-audio', '', d)}"
IMAGE_INSTALL:append:mel = " util-linux-mkfs connman"
IMAGE_INSTALL:append:mel = " ${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'haveged' if not any_incompatible(d, ['haveged'], 'GPL-3.0-only') else '', '', d)}"
