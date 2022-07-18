# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# Warn the user and disable rootfs resizing for non-GPLv3 configurations
#
# We use two events, as it seems ConfigParsed is firing multiple times in
# a build at the moment.

inherit incompatible-packages-check

python resize_gpl_warn () {
    if d.getVar('WARN_RESIZE_GPL', True):
        bb.warn('Resizing the root filesystem to the capacity of the media has been enabled in local.conf (WKS_FILE set to a non-fixed-size image, and 96boards-tools included in MACHINE_EXTRA_RECOMMENDS), however this is a GPL-3.0 incompatible build. This configuration is invalid, as the script we use requires recent GNU Parted, which is GPL-3.0. Removing 96boards-tools from MACHINE_EXTRA_RECOMMENDS. You may wish to alter WKS_FILE to a fixed size image in conf/local.conf, as otherwise the rootfs will not be the size of the media. Doing so, or commenting out the line which adds 96boards-tools, will silence this warning.')
}
resize_gpl_warn[eventmask] = "bb.event.BuildStarted"
addhandler resize_gpl_warn

python resize_gpl_check () {
    rrecs = d.getVar('MACHINE_EXTRA_RRECOMMENDS', True).split()
    if (any_incompatible(d, ['96boards-tools'], 'GPL-3.0-only') and
            '96boards-tools' in rrecs):
        wks_file = d.getVar('WKS_FILE', True)
        if wks_file.endswith('-sd.wks.in') or wks_file.endswith('.wks'):
            d.setVar('WARN_RESIZE_GPL', '1')
        d.setVar('MACHINE_EXTRA_RRECOMMENDS:remove', '96boards-tools')
}
resize_gpl_check[eventmask] = "bb.event.ConfigParsed"
addhandler resize_gpl_check
