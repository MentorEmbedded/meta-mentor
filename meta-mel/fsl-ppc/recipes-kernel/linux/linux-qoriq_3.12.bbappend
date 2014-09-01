# Support config fragments, and configure for lttng
inherit cml1-config kernel-config-lttng

DEFCONFIG = "${KERNEL_DEFCONFIG}"

python () {
    d.setVar("do_configure", 'kernel_do_configure')
}

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://nbd.cfg \
                   file://autofs.cfg"

SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"
