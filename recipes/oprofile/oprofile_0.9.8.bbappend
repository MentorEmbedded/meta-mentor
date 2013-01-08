PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS_prepend := "${THISDIR}/oprofile:"
SRC_URI += "\
    file://0001-OProfile-doesn-t-build-for-32-bit-ppc-the-operf_util.patch \
    file://0002-Handle-early-perf_events-kernel-without-PERF_RECORD_.patch \
    file://0003-Fix-up-configure-to-handle-architectures-that-do-not.patch \
    file://configure-pfm-cross.patch \
"

do_configure () {
	find ${S}/* -type f -print0 | xargs -0 sed -i 's#ROOTHOME#${ROOT_HOME}#'
	cp ${WORKDIR}/acinclude.m4 ${S}/
	autotools_do_configure
}

FILES_${PN}-staticdev += "${libexecdir}/*.a"
