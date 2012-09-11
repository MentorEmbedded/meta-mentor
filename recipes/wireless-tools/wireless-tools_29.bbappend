PRINC := "${@int(PRINC) + 1}"
SRC_URI += "file://ldflags.patch"
FILESEXTRAPATHS_prepend := "${THISDIR}:"
