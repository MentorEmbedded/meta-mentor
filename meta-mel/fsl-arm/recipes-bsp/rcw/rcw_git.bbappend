do_deploy_append () {
	cd ${DEPLOYDIR}
	# Install RCW in main deploy directory
	install -m 0755 rcw/ls1021atwr/RSR_PPS_70/rcw_1000.bin rcw_1000.bin
	install -m 0755 rcw/ls1021atwr/SSR_PPN_20/rcw_1000_lpuart.bin rcw_1000_lpuart.bin
}
