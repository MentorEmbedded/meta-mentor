# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/files:"
SRC_URI:append:feature-mentor-staging = " file://0001-initramfs-framework-finish-move-mounts-to-rootfs-bef.patch"
