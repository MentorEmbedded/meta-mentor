# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend := "${THISDIR}/qtbase:"
SRC_URI:append:feature-mentor-staging = " file://Fix-note-alignment.patch"
