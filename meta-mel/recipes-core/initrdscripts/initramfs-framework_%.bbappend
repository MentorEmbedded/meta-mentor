# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:initramfs-module-lvm += "lvm2"
RRECOMMENDS:${PN}-base += "initramfs-module-lvm"
