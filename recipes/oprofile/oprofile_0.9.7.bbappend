PRINC := "${@int(PRINC) + 2}"
DEPENDS = "popt binutils-libs"
RDEPENDS_${PN} = ""
FILES_${PN}-staticdev += "${libexecdir}/*.a"
