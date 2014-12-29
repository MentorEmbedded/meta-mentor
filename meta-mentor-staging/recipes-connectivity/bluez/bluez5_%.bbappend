FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://bluetooth" 

inherit update-rc.d


INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME_${PN} = "bluetooth"
INITSCRIPT_PARAMS_${PN} = "defaults"


do_install_append () {
        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 ${WORKDIR}/bluetooth ${D}${sysconfdir}/init.d/bluetooth
}
