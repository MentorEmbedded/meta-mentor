KERNEL_FEATURES_remove_minnow = "features/drm-emgd/drm-emgd-1.18"

python () {
    srcs = d.getVar('SRC_URI', False)
    srcs = srcs.replace(',emgd-1.18', '').replace(',emgd', '')
    d.setVar('SRC_URI', srcs)
}

KBRANCH_minnow = "${@base_conditional('RT_KERNEL_MINNOW', 'yes', 'standard/preempt-rt/minnow', 'standard/base', d)}"
SRCREV_machine_pn-linux-yocto_minnow = "${@base_conditional('RT_KERNEL_MINNOW', 'yes', '713598d06311629f4e27c95e5e7835f329b28572', '21df0c8486e129a4087970a07b423c533ae05de7', d)}"
