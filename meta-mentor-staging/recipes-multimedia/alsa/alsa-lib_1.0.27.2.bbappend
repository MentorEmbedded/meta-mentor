FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://direct-plugins-variable-period-size.patch \
            file://1-plug_null_avail.patch \
            file://2-extplug.patch         \
            file://3-plugin_atomic.patch   \
            file://plug_fix_rate_converter_config.patch \
"
