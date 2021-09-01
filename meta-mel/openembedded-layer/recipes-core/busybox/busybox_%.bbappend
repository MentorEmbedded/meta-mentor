FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGECONFIG[fbset] = ",,,"
SRC_URI .= "${@bb.utils.contains('PACKAGECONFIG', 'fbset', ' file://fbset.cfg', '', d)}"
RRECOMMENDS:${PN} .= "${@bb.utils.contains('PACKAGECONFIG', 'fbset', ' fbset-modes', '', d)}"
