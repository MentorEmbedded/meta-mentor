# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# When we're using an external toolchain, we don't want to ship a newly built
# toolchain inside the Yocto SDK. Normally meta-environment comes from the
# same packagegroup which installs the toolchain, so add that back in
# explicitly.
python () {
    if oe.utils.inherits(d, 'populate_sdk_base'):
        host_task = d.getVar('TOOLCHAIN_HOST_TASK', True)
        tcmode = d.getVar('TCMODE', True)
        packagegroup = d.expand('packagegroup-cross-canadian-${MACHINE}')
        if packagegroup in host_task.split() and tcmode.startswith('external'):
            d.setVar('TOOLCHAIN_HOST_TASK:remove', 'packagegroup-cross-canadian-${MACHINE}')
            d.setVar('TOOLCHAIN_HOST_TASK:append', ' meta-environment-${MACHINE}')
}
