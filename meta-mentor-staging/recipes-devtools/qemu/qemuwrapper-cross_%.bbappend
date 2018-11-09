do_install_append () {
	rm -f ${D}${bindir_crossscripts}/qemuwrapper
 
	qemu_options='${QEMU_OPTIONS} -E LD_LIBRARY_PATH=$D${libdir}:$D${base_libdir}'

	cat >> ${D}${bindir_crossscripts}/${MLPREFIX}qemuwrapper << EOF
#!/bin/sh
set -x

$qemu_binary $qemu_options "\$@"
EOF

	chmod +x ${D}${bindir_crossscripts}/${MLPREFIX}qemuwrapper
}
