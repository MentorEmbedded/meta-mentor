# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

do_compile:append:mel () {
    # Work around a toolchain issue with the default resampler (speex-float-N)
    # by using speex-fixed-N. JIRA: SB-1495
    set_cfg_value src/daemon/daemon.conf resample-method speex-fixed-3
}

RDEPENDS:pulseaudio-server:append:mel = "\
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-cli \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-echo-cancel \
"
