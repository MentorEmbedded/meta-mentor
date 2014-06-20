do_configure_append () {
        sed -i 's/org.bluez.Agent"/org.bluez.Agent1"/' ${WORKDIR}/bluetooth.conf
}
FILES_${PN}-obex += "${exec_prefix}/lib/systemd/user/obex.service"
