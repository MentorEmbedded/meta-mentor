PR .= ".2"
FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

ALLOW_EMPTY_${PN}-hwclock = "1"
ALLOW_EMPTY_${PN}-httpd = "1"
