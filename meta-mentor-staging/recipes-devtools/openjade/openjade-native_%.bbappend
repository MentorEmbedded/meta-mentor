# Statically link local libs to avoid gold link issue [YOCTO #2972]
EXTRA_OECONF += "--enable-static --disable-shared"

python () {
    inst = d.getVar("do_install", False).splitlines(True)
    inst = (l for l in inst if ".libs/openjade" not in l and "oe_libinstall" not in l)
    d.setVar("do_install", "".join(inst))
}

do_install_append () {
	install -m 0755 jade/openjade ${D}${bindir}/openjade
}
