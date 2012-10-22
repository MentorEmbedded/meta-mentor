PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://0001-Add-additional-probe-modules-to-kern_modules_list.patch"
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*|mips.*)-linux.*'
