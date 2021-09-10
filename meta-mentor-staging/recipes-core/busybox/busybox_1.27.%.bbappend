FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append_mel = " file://reboot.cfg"

do_compile_append_mel() {
	# Move arch/link to BINDIR to match coreutils
	sed -i "s:^/bin/arch:/usr/bin/arch:" busybox.links*
	sed -i "s:^/bin/link:/usr/bin/link:" busybox.links*
}
