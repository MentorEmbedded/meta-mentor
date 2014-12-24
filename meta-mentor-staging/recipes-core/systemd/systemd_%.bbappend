FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://01-create-run-lock.conf"

do_install_append() {
	install -m 0644 ${WORKDIR}/01-create-run-lock.conf ${D}${sysconfdir}/tmpfiles.d/
}

pkg_postinst_udev-hwdb () {
	if test -n "$D"; then
		${@qemu_run_binary(d, '$D', '${base_bindir}/udevadm')} hwdb --update \
			--root $D
		chown root:root $D${sysconfdir}/udev/hwdb.bin
	else   
		udevadm hwdb --update
	fi
}

