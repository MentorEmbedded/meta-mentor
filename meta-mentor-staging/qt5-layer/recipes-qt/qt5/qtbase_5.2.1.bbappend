FILESEXTRAPATHS_prepend := "${THISDIR}/qtbase:"
SRC_URI += "file://qtbase-CVE-2014-0190.patch"


# Add missing libxi to DEPENDS for xinput packageconfigs
PACKAGECONFIG[xinput] = "-xinput,-no-xinput,libxi"
PACKAGECONFIG[xinput2] = "-xinput2,-no-xinput2,libxi"

