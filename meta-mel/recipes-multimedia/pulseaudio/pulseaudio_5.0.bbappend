FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

VIRTUAL-RUNTIME_bluetooth-stack ?= "bluez5"
PACKAGECONFIG := "${@PACKAGECONFIG.replace('bluez5', '${VIRTUAL-RUNTIME_bluetooth-stack}')}"

# Strictly for MEL, we only like systemd starting up our PA server
# so no autospawning.
SRC_URI_append = " file://disable_autospawn_by_default.patch \
"

do_install_append_mel () {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
