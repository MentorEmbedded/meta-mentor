# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

DESCRIPTION = "MEL Image initramfs"

PACKAGE_INSTALL = "initramfs-framework-base ${VIRTUAL-RUNTIME_base-utils} initramfs-module-udev udev base-passwd ${ROOTFS_BOOTSTRAP_INSTALL}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "${MLPREFIX}mel-initramfs-image"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_LINGUAS = ""

LICENSE = "MIT"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# We don't care about root password for login on initramfs images
IMAGE_QA_COMMANDS:remove = "image_check_zapped_root_password"

BAD_RECOMMENDATIONS += "busybox-syslog"

# We don't need selinux labels in initramfs
IMAGE_PREPROCESS_COMMAND:remove = "selinux_set_labels ;"

COMPATIBLE_HOST:mel = "(arm|aarch64|i.86|x86_64).*-linux"

# Take care of warnings due to dependency on noexec ${INITRAMFS_IMAGE}:do_image_complete's
# do_packagedata() in our initramfs image for now. The fix needs to come from oe-core image
# bbclass when available, after which this can be removed
deltask do_packagedata
