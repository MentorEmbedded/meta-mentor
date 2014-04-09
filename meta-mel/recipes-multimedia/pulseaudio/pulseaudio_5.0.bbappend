PACKAGECONFIG_remove = "bluez5"

do_install_append_mel () {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
