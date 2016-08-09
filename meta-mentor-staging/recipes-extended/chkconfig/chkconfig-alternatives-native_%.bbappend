obey_variables () {
	sed -i 's,ALTERNATIVES_ROOT,OPKG_OFFLINE_ROOT,' ${S}/alternatives.c
}
