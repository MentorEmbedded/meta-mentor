# We want a package manager in our base image
IMAGE_FEATURES_append_mel = " package-management"

# We want libgcc to always be available, even if nothing needs it, as its size
# is minimal, and it's often needed by third party (or QA) binaries
IMAGE_INSTALL_append_mel = " libgcc"

# We use core-image-base as a basic non-graphical image, so we don't want
# a splashscreen (not all the BSPs even have a framebuffer at this point).
IMAGE_FEATURES := "${@oe_filter_out('splash$' if 'mel' in '${OVERRIDES}'.split(':') else '$', \
                                    '${IMAGE_FEATURES}', d)}"
