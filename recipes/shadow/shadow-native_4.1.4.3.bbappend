PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://add_root_cmd_groupmems.patch"
