COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*|mips.*)-linux.*'
FILESEXTRAPATHS_append := ":${THISDIR}/files"
SRC_URI_append += " file://URCU-PATCHadd-simple-mips-support.patch "
