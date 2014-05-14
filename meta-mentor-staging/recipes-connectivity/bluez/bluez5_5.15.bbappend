do_configure_append () {
        sed -i 's/org.bluez.Agent"/org.bluez.Agent1"/' ${WORKDIR}/bluetooth.conf
}

