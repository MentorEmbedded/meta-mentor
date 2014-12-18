FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://pulseaudio.service \
		           file://pulseaudio \
			"

RDEPENDS_pulseaudio-server += "\
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-cli \
    pulseaudio-module-bluetooth-discover \
    pulseaudio-module-esound-protocol-unix \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-echo-cancel \
"

RDEPENDS_pulseaudio-server += "${@base_contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d )}"

inherit update-rc.d systemd

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "pulseaudio"
INITSCRIPT_PARAMS_${PN}-server = "defaults"


SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE_${PN}-server = "pulseaudio.service"

RDEPENDS_pulseaudio-module-systemd-login =+ "systemd"
RDEPENDS_pulseaudio-server += "\
        ${@base_contains('DISTRO_FEATURES', 'systemd', 'pulseaudio-module-systemd-login', '', d)}"


do_install_append () {
	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/pulseaudio.service ${D}${systemd_unitdir}/system
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/pulseaudio ${D}${sysconfdir}/init.d/

    if ! ${@base_contains('PACKAGECONFIG', 'x11', 'true', 'false', d)}; then
        # If we have no x11 feature, then consolekit can't be built. We don't
        # want to emit a pulseaudio-module-console-kit in this case, otherwise
        # our feed will have a package that will never be installable.
        rm -f ${D}${libdir}/pulse-${PV}/modules/module-console-kit.so
    fi
}

python () {
    rdeps = d.getVar('RDEPENDS_pulseaudio-server', False)
    rdeps = rdeps.replace("${@base_contains('DISTRO_FEATURES', 'x11', 'pulseaudio-module-console-kit', '', d)}",
                          "${@base_contains('PACKAGECONFIG', 'x11', 'pulseaudio-module-console-kit', '', d)}")
    d.setVar('RDEPENDS_pulseaudio-server', rdeps)
}

GROUPADD_PARAM_pulseaudio-server =+ "pulse-access; "
