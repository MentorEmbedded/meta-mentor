PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://flac-1.2.1-asm.patch"
