# Support config fragments, and configure for lttng
inherit cml1-config kernel-config-lttng

DEFCONFIG = "${KERNEL_DEFCONFIG}"

python () {
    d.setVar("do_configure", 'kernel_do_configure')
}
