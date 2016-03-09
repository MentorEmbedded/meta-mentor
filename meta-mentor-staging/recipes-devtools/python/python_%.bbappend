# Set PYTHONHOME in the python wrapper, so we don't need to set it in the sdk
# environment-setup script.
do_install_append_class-nativesdk () {
	rm -f ${D}${bindir}/python2.7
	mv ${D}${bindir}/python2.7.real ${D}${bindir}/python2.7
	create_wrapper ${D}${bindir}/python2.7 PYTHONHOME='${prefix}' TERMINFO_DIRS='${sysconfdir}/terminfo:/etc/terminfo:/usr/share/terminfo:/usr/share/misc/terminfo:/lib/terminfo'
}
