do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/${RULE} ${D}${sysconfdir}/udev/rules.d/
}
