FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "\
    file://0001-systemd-udevd-propagate-mounts-umounts-services-to-s.patch \
    file://add-argument-for-valgrind.patch \
"

PACKAGECONFIG[valgrind] = "--with-valgrind,--without-valgrind,valgrind,"
CFLAGS .= "${@base_contains('PACKAGECONFIG', 'valgrind$', ' -DVALGRIND=1', '', d)}"

do_install_append() {
	if ! ${@bb.utils.contains('PACKAGECONFIG', 'resolved', 'true', 'false', d)}; then
		# if resolved is disabled, it won't handle the link of resolv.conf, so
		# set it up ourselves
		ln -s ../run/resolv.conf ${D}${sysconfdir}/resolv.conf
		echo 'L! ${sysconfdir}/resolv.conf - - - - ../run/resolv.conf' >>${D}${exec_prefix}/lib/tmpfiles.d/etc.conf
		echo 'f /run/resolv.conf 0644 root root' >>${D}${exec_prefix}/lib/tmpfiles.d/systemd.conf
	fi
}

FILES_${PN} += "${sysconfdir}/resolv.conf"

pkg_postinst_${PN} () {
	sed -e '/^hosts:/s/\s*\<myhostname\>//' \
		-e 's/\(^hosts:.*\)\(\<files\>\)\(.*\)\(\<dns\>\)\(.*\)/\1\2 myhostname \3\4\5/' \
		-i $D${sysconfdir}/nsswitch.conf
}

pkg_prerm_${PN} () {
	sed -e '/^hosts:/s/\s*\<myhostname\>//' \
		-e '/^hosts:/s/\s*myhostname//' \
		-i $D${sysconfdir}/nsswitch.conf
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
