PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BP}:"
SRC_URI += "file://mkbuiltins_have_stringize.patch"
