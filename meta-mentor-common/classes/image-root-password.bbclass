# Enable use of the 'ROOT_PASSWORD' variable to set the root password for your
# image or images. In addition to setting to a specific password, it also
# handles special cases. If set to '0', empty root password is explicitly
# allowed. If set to '*', root login is explicitly disabled.

ROOT_PASSWORD ?= ""

EMPTY_ROOT_PASSWORD = "${@'empty-root-password' if d.getVar('ROOT_PASSWORD', True) == '0' else ''}"
IMAGE_FEATURES += "${EMPTY_ROOT_PASSWORD}"

inherit extrausers

# This variable indirection allows for the possibility of programmatically
# generating the root password, if so desired, without mucking up bitbake's
# variable checksums.
ACTUAL_ROOT_PASSWORD = "${ROOT_PASSWORD}"
EXTRA_USERS_PARAMS_prepend = "${@'usermod -P \'${ACTUAL_ROOT_PASSWORD}\' root;' if d.getVar('ACTUAL_ROOT_PASSWORD') not in ['', '0', '*'] else ''}"
