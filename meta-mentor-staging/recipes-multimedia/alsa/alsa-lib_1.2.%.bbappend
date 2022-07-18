# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/${BPN}:"

SRC_URI:append:feature-mentor-staging = "\
    file://plug_fix_rate_converter_config.patch \
    file://fix_dshare_status.patch \
"
