FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
RRECOMMENDS_${PN} += "os-release"

SRC_URI += "file://10-dhcp.network"

do_install_append() {
        install -m 0644 ${WORKDIR}/10-dhcp.network ${D}${sysconfdir}/systemd/network/dhcp.network
}

