do_compile_append_mel () {
    # Work around a toolchain issue with the default resampler (speex-float-N)
    # by using speex-fixed-N.
    set_cfg_value src/daemon.conf resample-method speex-fixed-3
}

RDEPENDS_pulseaudio-server_append_mel = "\
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-cli \
    pulseaudio-module-esound-protocol-unix \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-echo-cancel \
"
