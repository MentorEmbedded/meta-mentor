FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://disable-altera-edac.cfg \
            file://enable-nfs-server.cfg \
            file://lttng.cfg \
            file://bluetooth.cfg \
            file://wireless.cfg \
            file://kgdb.cfg \
            file://filesystems.cfg \
	    file://network.cfg \
            "

# Fix FS mount messages during boot, Wifi debug messages and SPI Warn-ON
SRC_URI_append = " file://0001-fs-Makefile-Re-order-EXT4-prior-to-EXT2-or-EXT3.patch \
		   file://0001-wireless-regulatory-reduce-log-level-of-CRDA-related.patch \
		   file://0001-FogBugz-355420-2-dts-socfpga-Fix-spidev-WARN_ON-duri.patch \
		 "

# Fix KGDBOC hang issue
SRC_URI_append = " file://0001-ARM-8425-1-kgdb-Don-t-try-to-stop-the-machine-when-s.patch"
