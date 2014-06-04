do_install_append() {
   echo ${MACHINE} "		"127.0.1.1 >> ${D}${sysconfdir}/hosts
}
