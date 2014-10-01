KERNEL_FEATURES_remove_minnow = "features/drm-emgd/drm-emgd-1.18"

python () {
    srcs = d.getVar('SRC_URI', False)
    srcs = srcs.replace(',emgd-1.18', '').replace(',emgd', '')
    d.setVar('SRC_URI', srcs)
}

RT_KERNEL_MINNOW ?= "no"
LINUX_KERNEL_TYPE = "${@'preempt-rt' if '${RT_KERNEL_MINNOW}' == 'yes' else 'standard'}"
KBRANCH_minnow = "${@'standard/preempt-rt/minnow' if '${RT_KERNEL_MINNOW}' == 'yes' else 'standard/base'}"
SRCREV_machine_minnow = "${@'052e915a9234d13f54b52d3e4c59d9b6a087bc5c' if '${RT_KERNEL_MINNOW}' == 'yes' else 'aa677a2d02677ec92d59a8c36d001cf2f5cf3260'}"
