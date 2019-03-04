FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "\
    file://plug_fix_rate_converter_config.patch \
    file://fix_dshare_status.patch \
"
