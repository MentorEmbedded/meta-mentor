FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"
