do_install_append () {
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
