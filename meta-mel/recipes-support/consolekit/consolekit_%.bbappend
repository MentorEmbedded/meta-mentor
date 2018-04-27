FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://console-kit-log-system-shutdown.service.in \
    file://console-kit-shutdown-handler \
"

do_install_append() {

    shutdown_handler="console-kit-shutdown-handler"
    shutdown_service="console-kit-log-system-shutdown.service"

    # install script with logic to choose between "stop" and "restart"
    install -d ${D}${sbindir}
    install -m 755 ${WORKDIR}/${shutdown_handler} ${D}${sbindir}

    # install "shutdown" service and auto-start softlink
    sed -e 's,@sbindir@,${sbindir},g' ${WORKDIR}/${shutdown_service}.in > ${WORKDIR}/${shutdown_service}
    install -d ${D}${systemd_system_unitdir}
    install -m 644 ${WORKDIR}/${shutdown_service} ${D}${systemd_system_unitdir}

    install -d ${D}${systemd_system_unitdir}/basic.target.wants
    ln -s ../${shutdown_service} ${D}${systemd_system_unitdir}/basic.target.wants

    # remove unused from basic package, these are replaced by the one "shutdown" service
    rm -f ${D}${systemd_system_unitdir}/halt.target.wants/console-kit-log-system-stop.service
    rm -f ${D}${systemd_system_unitdir}/poweroff.target.wants/console-kit-log-system-stop.service
    rm -f ${D}${systemd_system_unitdir}/reboot.target.wants/console-kit-log-system-restart.service
    rm -f ${D}${systemd_system_unitdir}/kexec.target.wants/console-kit-log-system-restart.service
    rm -f ${D}${systemd_system_unitdir}/console-kit-log-system-stop.service
    rm -f ${D}${systemd_system_unitdir}/console-kit-log-system-restart.service
}
