FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${BPN}:"

SRC_URI_append_feature-mentor-staging = "\
    file://plug_fix_rate_converter_config.patch \
    file://fix_dshare_status.patch \
"
