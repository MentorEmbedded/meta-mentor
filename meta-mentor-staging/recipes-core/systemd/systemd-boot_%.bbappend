# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend:feature-mentor-staging := "${THISDIR}/${PN}:"

SRC_URI:append:feature-mentor-staging = " file://0001-Use-an-array-for-efi-ld-to-allow-for-ld-arguments.patch"

LDFLAGS:remove:feature-mentor-staging := "${@ " ".join(d.getVar('LD').split()[1:])} "
EXTRA_OEMESON:append:feature-mentor-staging = ' "-Defi-ld=${@meson_array("LD", d)}"'
