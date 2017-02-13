# opkg-configure has been entirely superceded by run-postinsts, which opkg
# depends upon, so remove it
SYSTEMD_SERVICE_${PN} = ""
do_install_append () {
    rm -rf ${D}${systemd_unitdir}
    rmdir ${D}/lib 2>/dev/null || :
}
