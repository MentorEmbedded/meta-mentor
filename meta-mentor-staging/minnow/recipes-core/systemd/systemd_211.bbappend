FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_minnow = " file://10-dhcp.network"

do_install_append_minnow () {
        install -m 0644 ${WORKDIR}/10-dhcp.network ${D}${sysconfdir}/systemd/network/dhcp.network
}
