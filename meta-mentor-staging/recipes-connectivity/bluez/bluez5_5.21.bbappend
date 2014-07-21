do_configure_append () {
	sed -i '/<\/policy>/i\ \ \ \ <allow send_type="method_call"\/>' ${WORKDIR}/bluetooth.conf
}
