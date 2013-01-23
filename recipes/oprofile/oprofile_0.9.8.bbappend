PRINC := "${@int(PRINC) + 1}"

do_configure () {
	find ${S}/* -type f -print0 | xargs -0 sed -i 's#ROOTHOME#${ROOT_HOME}#'
	cp ${WORKDIR}/acinclude.m4 ${S}/
	autotools_do_configure
}

FILES_${PN}-staticdev += "${libexecdir}/*.a"
