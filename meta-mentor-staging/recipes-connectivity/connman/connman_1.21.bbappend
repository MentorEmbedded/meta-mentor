FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://fix-stoping-interfaces-at-start.patch \
            file://connman.service \
            "

PACKAGECONFIG_append_pn-connman = " bluetooth wifi 3g"

do_install_append() {
    cp -f ${WORKDIR}/connman.service ${D}${base_libdir}/systemd/system/
}

