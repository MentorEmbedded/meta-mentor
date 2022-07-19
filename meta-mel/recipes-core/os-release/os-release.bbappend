# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

OS_RELEASE_FIELDS:mel = "PRETTY_NAME NAME VERSION_ID VERSION VERSION_CODENAME ID HOME_URL SUPPORT_URL BUG_REPORT_URL"

ID:mel = "flex-os"
NAME:mel = "Flex OS"
VERSION:mel = "${DISTRO_VERSION}${@' (%s)' % DISTRO_CODENAME if 'DISTRO_CODENAME' in d else ''}"
VERSION_ID:mel = "${DISTRO_VERSION}"
VERSION_CODENAME:mel = "${@'(%s)' % DISTRO_CODENAME if 'DISTRO_CODENAME' in d else ''}"
PRETTY_NAME:mel = "${DISTRO_NAME} ${VERSION}"
