do_configure_append () {
	sed -i '/<\/policy>/i\ \ \ \ <allow send_type="method_call"\/>' ${WORKDIR}/bluetooth.conf
}

FILES_${PN}-obex += "${exec_prefix}/lib/systemd/user/obex.service"
