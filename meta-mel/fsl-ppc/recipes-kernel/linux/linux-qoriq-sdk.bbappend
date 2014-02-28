# Support config fragments, and configure for lttng
inherit cml1-config kernel-config-lttng

DEFCONFIG = "${KERNEL_DEFCONFIG}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files"

SRC_URI_append_p4080ds += "file://p4080-config.patch"

python () {
    d.setVar("do_configure", 'kernel_do_configure')
}
