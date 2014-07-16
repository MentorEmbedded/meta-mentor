FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append += " \
    file://ps7_init.h \
    file://ps7_init.c \
    file://uEnv.txt \
"

do_configure_prepend () {
	cp ${WORKDIR}/ps7_init.h ${S}/board/xilinx/zynq/
	cp ${WORKDIR}/ps7_init.c ${S}/board/xilinx/zynq/
}

do_deploy_append () {
	if [ -e ${WORKDIR}/uEnv.txt ]; then
		cp ${WORKDIR}/uEnv.txt ${DEPLOYDIR}
	fi
	if [ -e ${WORKDIR}/fpga.bin ]; then
		cp ${WORKDIR}/fpga.bin ${DEPLOYDIR}
	fi
	if [ -e ${B}/boot.bin ]; then
		cp ${B}/boot.bin ${DEPLOYDIR}
	fi
}
