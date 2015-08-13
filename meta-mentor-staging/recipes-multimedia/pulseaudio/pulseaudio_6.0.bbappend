# Since many embedded systems don't have non-root users, it's useful to be
# able to use pulseaudio autospawn for root as well. Autospawn will only be
# used if the systemd packageconfig is not enabled, otherwise it will rely on
# systemd's user services to spawn it.
PACKAGECONFIG[autospawn-for-root] = ",,,"

EXTRA_OECONF += "--with-systemduserunitdir=${systemd_user_unitdir}"

RDEPENDS_pulseaudio-module-systemd-login += "systemd"
RDEPENDS_pulseaudio-server += "\
    ${@base_contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@base_contains('PACKAGECONFIG', 'bluez4', 'pulseaudio-module-bluetooth-discover', '', d)} \
    ${@base_contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"

set_cfg_value () {
    sed -i -e "s/\(; *\)\?$2 =.*/$2 = $3/" "$1"
    if ! grep -q "^$2 = $3\$" "$1"; then
        die "Use of sed to set '$2' to '$3' in '$1' failed"
    fi
}

do_compile_append () {
    if ${@bb.utils.contains('PACKAGECONFIG', 'autospawn-for-root', 'true', 'false', d)}; then
        set_cfg_value src/client.conf allow-autospawn-for-root yes
    fi
}

do_install_append () {
    if ! ${@base_contains('PACKAGECONFIG', 'x11', 'true', 'false', d)}; then
        # If we have no x11 feature, then consolekit can't be built. We don't
        # want to emit a pulseaudio-module-console-kit in this case, otherwise
        # our feed will have a package that will never be installable.
        rm -f ${D}${libdir}/pulse-${PV}/modules/module-console-kit.so
    fi
}
