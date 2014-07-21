do_install_append() {
   echo 127.0.1.1 "		"${MACHINE} >> ${D}${sysconfdir}/hosts
}
