PRINC := "${@int(PRINC) + 1}"

SRC_URI_append_mips64 = " file://rmb-mips.patch"

