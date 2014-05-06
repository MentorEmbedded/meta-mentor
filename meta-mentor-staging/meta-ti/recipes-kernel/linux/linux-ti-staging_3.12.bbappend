DEPENDS += "bc-native"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://0001-omap2plus-Enable-config-options-for-proper-systemd-o.patch ', '', d)}"
