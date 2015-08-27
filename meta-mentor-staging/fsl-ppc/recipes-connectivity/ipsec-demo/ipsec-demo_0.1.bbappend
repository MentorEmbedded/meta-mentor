do_install_append() {
    chown -R root:root ${D}${datadir}/test_setkey
}
