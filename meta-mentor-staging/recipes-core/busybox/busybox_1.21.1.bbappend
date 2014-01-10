PRINC := "${@int(PRINC) + 3}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://fbset.patch"
