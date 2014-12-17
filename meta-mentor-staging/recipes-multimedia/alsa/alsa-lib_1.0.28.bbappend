FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://direct-plugins-variable-period-size.patch \
            file://1-plug_null_avail.patch \
            file://2-extplug.patch         \
            file://3-plugin_atomic.patch   \
            file://plug_fix_rate_converter_config.patch \
            file://fix_dshare_status.patch \
            file://alsa_lib_drain_silence_padding.patch \
            file://dshare_slave_xrun_recovery.patch;striplevel=3 \
            file://0001-Protect-from-freeing-semaphore-when-already-in-use.patch \
"
