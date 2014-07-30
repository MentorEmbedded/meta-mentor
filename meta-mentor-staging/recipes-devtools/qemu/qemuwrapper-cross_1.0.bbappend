do_install_append () {
	qemu_binary=${@qemu_target_binary(d)}
	qemu_options='${@d.getVar("QEMU_OPTIONS_%s" % d.getVar('PACKAGE_ARCH', True), True) or d.getVar('QEMU_OPTIONS', True) or ""}'
	sed -i -e "2s/^.*/$qemu_binary $qemu_options \"\$@\"/" ${D}${bindir_crossscripts}/qemuwrapper
}
