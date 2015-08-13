FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append_mel () {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}

RDEPENDS_pulseaudio-server += "\
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-cli \
    pulseaudio-module-esound-protocol-unix \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-echo-cancel \
"
