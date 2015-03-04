FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://init"

inherit update-rc.d

systemd_userunitdir ?= "${systemd_unitdir}/user"
EXTRA_OECONF += "--with-systemduserunitdir=${systemd_userunitdir}"

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "pulseaudio"
INITSCRIPT_PARAMS_${PN}-server = "defaults"

FILES_${PN}-server += "${systemd_userunitdir}/pulseaudio.*"

RDEPENDS_pulseaudio-module-systemd-login += "systemd"
RDEPENDS_pulseaudio-server += "\
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-cli \
    pulseaudio-module-esound-protocol-unix \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-echo-cancel \
    \
    ${@base_contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'bluez4', 'pulseaudio-module-bluetooth-discover', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'bluez5', 'pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"

do_install_append () {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/pulseaudio

    if ! ${@base_contains('PACKAGECONFIG', 'x11', 'true', 'false', d)}; then
        # If we have no x11 feature, then consolekit can't be built. We don't
        # want to emit a pulseaudio-module-console-kit in this case, otherwise
        # our feed will have a package that will never be installable.
        rm -f ${D}${libdir}/pulse-${PV}/modules/module-console-kit.so
    fi
}

GROUPADD_PARAM_pulseaudio-server =+ "pulse-access;"

# If we have a system rather than user service, ensure that it's enabled
python () {
    if ('systemd' in d.getVar('PACKAGECONFIG', True).split() and
        d.getVar('systemd_userunitdir', True) == d.expand('${systemd_unitdir}/system')):
        d.setVar('SYSTEMD_PACKAGES', '${PN}-server')
}
