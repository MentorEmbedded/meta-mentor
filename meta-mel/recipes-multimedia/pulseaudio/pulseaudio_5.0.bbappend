VIRTUAL-RUNTIME_bluetooth-stack ?= "bluez5"
PACKAGECONFIG := "${@PACKAGECONFIG.replace('bluez5', '${VIRTUAL-RUNTIME_bluetooth-stack}')}"

do_install_append_mel () {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
