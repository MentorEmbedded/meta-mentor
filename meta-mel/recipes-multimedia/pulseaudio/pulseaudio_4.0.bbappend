PACKAGECONFIG[bluez] = "--enable-bluez,--disable-bluez,virtual/libbluetooth sbc"

do_install_append_mel () {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
