FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG[fbset] = ",,,"
SRC_URI .= "${@base_contains('PACKAGECONFIG', 'fbset', ' file://fbset.cfg', '', d)}"
RRECOMMENDS_${PN} .= "${@base_contains('PACKAGECONFIG', 'fbset', ' fbset-modes', '', d)}"
