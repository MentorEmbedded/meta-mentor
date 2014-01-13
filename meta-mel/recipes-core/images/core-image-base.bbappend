# We want a package manager in our base image
IMAGE_FEATURES_append_mel = " package-management"

# We want libgcc to always be available, even if nothing needs it, as its size
# is minimal, and it's often needed by third party (or QA) binaries
IMAGE_INSTALL_append_mel = " libgcc"
