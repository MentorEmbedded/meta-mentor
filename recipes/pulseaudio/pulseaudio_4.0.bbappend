PACKAGECONFIG[gconf] = "--enable-gconf,--disable-gconf,gconf,"

do_install_append() {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
