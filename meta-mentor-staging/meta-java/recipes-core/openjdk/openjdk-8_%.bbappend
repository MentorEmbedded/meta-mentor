# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/${PN}:"

SRC_URI:append:feature-mentor-staging = " file://0001-PR3597-Potential-bogus-Wformat-overflow-warning-with.patch"

