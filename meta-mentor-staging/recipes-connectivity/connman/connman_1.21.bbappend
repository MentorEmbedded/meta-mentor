FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://fix-stoping-interfaces-at-start.patch \
            file://connman.service \
            "
do_install_append() {
    cp -f ${WORKDIR}/connman.service ${D}${base_libdir}/systemd/system/
}

