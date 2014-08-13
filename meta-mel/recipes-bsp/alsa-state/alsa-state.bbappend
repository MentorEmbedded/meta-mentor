# This recipe doesn't inherit systemd, so that doesn't remove the startup
# script, which makes sense, but if this ships its init script
# unconditionally, it ends up depending on initscripts-functions, which
# doesn't exist in the case where sysvinit isn't in DISTRO_FEATURES.

do_install_append () {
    if ${@'true' if 'sysvinit' not in DISTRO_FEATURES.split() else 'false'}; then
        rm -rf "${D}${sysconfdir}/init.d"
    fi
}

#
# Package the asound.conf separately so it can be included
# even if the base package is not (as is the case for systemd
# based configurations).
#
FILES_${PN}_remove := "${sysconfdir}/asound.conf"
CONFFILES_${PN}_remove := "${sysconfdir}/asound.conf"
PACKAGES += "alsa-asound-conf"
FILES_alsa-asound-conf = " ${sysconfdir}/asound.conf"
CONFFILES_alsa-asound-conf = " ${sysconfdir}/asound.conf"
RRECOMMENDS_${PN}_append = " alsa-asound-conf"
RRECOMMENDS_alsa-states_append = " alsa-asound-conf"
ALLOW_EMPTY_${PN} = "1"
