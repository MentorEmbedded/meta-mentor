# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:mel = " \
    file://0001-Ensure-filesystems-are-still-mounted-when-consolekit.patch \
"
