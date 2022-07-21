# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/${PN}:"

# Interrupt streaming via CTRL-C
SRC_URI:append:feature-mentor-staging = " file://0001-alsa-utils-interrupt-streaming-via-signal.patch"
