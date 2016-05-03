FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG[fbset] = ",,,"
SRC_URI .= "${@bb.utils.contains('PACKAGECONFIG', 'fbset', ' file://fbset.cfg', '', d)}"
RRECOMMENDS_${PN} .= "${@bb.utils.contains('PACKAGECONFIG', 'fbset', ' fbset-modes', '', d)}"
