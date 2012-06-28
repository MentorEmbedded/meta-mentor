PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://rpm-no-dbconvert.patch"
