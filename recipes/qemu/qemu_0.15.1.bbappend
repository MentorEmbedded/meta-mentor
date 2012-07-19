PRINC := "${@int(PRINC) + 1}"
SRC_URI += "file://cflags-separator.patch"
FILESPATH_prepend := "${THISDIR}:"
