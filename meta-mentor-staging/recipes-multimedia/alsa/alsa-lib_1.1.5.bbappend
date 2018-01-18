FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "\
    file://1-plug_null_avail.patch \
    file://plug_fix_rate_converter_config.patch \
    file://fix_dshare_status.patch \
"
