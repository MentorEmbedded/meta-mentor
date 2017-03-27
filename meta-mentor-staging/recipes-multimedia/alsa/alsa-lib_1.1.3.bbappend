FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://direct-plugins-variable-period-size.patch \
            file://1-plug_null_avail.patch \
            file://2-extplug.patch         \
            file://plug_fix_rate_converter_config.patch \
            file://fix_dshare_status.patch \
            file://dshare_slave_xrun_recovery.patch \
"
