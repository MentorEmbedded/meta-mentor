FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://disable-altera-edac.cfg \
            file://enable-nfs-server.cfg \
            file://lttng.cfg \
            file://bluetooth.cfg \
            file://wireless.cfg \
            "
