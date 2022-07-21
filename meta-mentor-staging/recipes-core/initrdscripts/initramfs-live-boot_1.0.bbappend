# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/files:"

SRC_URI:append:feature-mentor-staging = " file://0001-initrdscripts-init-live.sh-Fixed-mounts-fail-to-move.patch"
