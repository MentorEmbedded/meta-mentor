do_install_append() {
        chown -R root:root ${D}${datadir}/jamvm/classes.zip
}

