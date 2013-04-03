MACHINE_KERNEL_PR_append = "b"

SRC_URI_append := "file://${THISDIR}/${PN}_${PV}/commit-4ff16c2.patch\
		   file://${THISDIR}/${PN}_${PV}/arm-tracehook/0001-ARM-add-support-for-the-generic-syscall.h-interface.patch\
		   file://${THISDIR}/${PN}_${PV}/arm-tracehook/0002-ARM-add-TRACEHOOK-support.patch\
		   file://${THISDIR}/${PN}_${PV}/arm-tracehook/0003-ARM-support-syscall-tracing.patch\
		   file://${THISDIR}/${PN}_${PV}/arm-tracehook/0004-syscall.h-include-linux-sched.h.patch\
		   file://${THISDIR}/${PN}_${PV}/stap-opts.cfg\
		   "
