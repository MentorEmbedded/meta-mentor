# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS:prepend := "${THISDIR}:"

dirs755:append:mel = "\
    ${sysconfdir}/alternatives \
    ${localstatedir}/lib/alternatives \
"
