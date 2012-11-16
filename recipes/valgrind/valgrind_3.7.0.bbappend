PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://external-toolchain-version.patch"
