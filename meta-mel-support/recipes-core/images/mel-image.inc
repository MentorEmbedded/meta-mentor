# We want a package manager in our base images
IMAGE_FEATURES += "package-management"

# We want libgcc to always be available, even if nothing needs it, as its size
# is minimal, and it's often needed by third party (or QA) binaries
IMAGE_INSTALL_append_mel = " libgcc"

LICENSE = "MIT"

inherit core-image image-sanity-incompatible

IMAGE_FEATURES .= "${@bb.utils.contains('COMBINED_FEATURES', 'alsa', ' tools-audio', '', d)}"
IMAGE_INSTALL += " util-linux connman"
