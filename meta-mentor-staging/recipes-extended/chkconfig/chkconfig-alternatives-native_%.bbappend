FILESEXTRAPATHS_prepend := "${THISDIR}/chkconfig-alternatives-native:"
SRC_URI += "file://0001-alternatives.c-obey-sysroot-for-facility-in-removeLi.patch"

obey_variables () {
	sed -i 's,ALTERNATIVES_ROOT,OPKG_OFFLINE_ROOT,' ${S}/alternatives.c
}
