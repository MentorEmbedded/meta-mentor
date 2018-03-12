FILESEXTRAPATHS_prepend_mel := "${THISDIR}/files:"

do_install_append_mel () {
        install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

FILES_${PN}_append_mel = " /dev"
