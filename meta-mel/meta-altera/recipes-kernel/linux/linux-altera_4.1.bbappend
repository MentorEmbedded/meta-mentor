FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://disable-altera-edac.cfg \
            file://enable-nfs-server.cfg \
            file://lttng.cfg \
            file://bluetooth.cfg \
            file://wireless.cfg \
            file://kgdb.cfg \
            file://filesystems.cfg \
            "

# Fix FS mount messages during boot
SRC_URI_append = " file://0001-fs-Makefile-Re-order-EXT4-prior-to-EXT2-or-EXT3.patch"
