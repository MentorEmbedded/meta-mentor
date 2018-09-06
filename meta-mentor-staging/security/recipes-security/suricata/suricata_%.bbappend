FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://tmpfiles.suricata"

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/tmpfiles.d
        install -m 0644 ${WORKDIR}/tmpfiles.suricata ${D}${sysconfdir}/tmpfiles.d/suricata.conf
    fi
}

pkg_postinst_${PN} () {
    if [ -z "$D" ]; then
        if command -v systemd-tmpfiles >/dev/null; then
            systemd-tmpfiles --create ${sysconfdir}/tmpfiles.d/suricata.conf
        elif [ -e ${sysconfdir}/init.d/populate-volatile.sh ]; then
            ${sysconfdir}/init.d/populate-volatile.sh update
        fi
    fi
    ${bindir}/suricata -c ${sysconfdir}/suricata.yaml -i eth0
}

FILES_${PN} += "${sysconfdir}/tmpfiles.d"
