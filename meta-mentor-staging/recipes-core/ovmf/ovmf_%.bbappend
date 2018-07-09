# The target build can fail due to parallelism as well, not just native
PARALLEL_MAKE = ""

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

# gcc8 fix from oe-core commit 278b00ddcc
SRC_URI += "\
    file://0001-BaseTools-header.makefile-add-Wno-stringop-truncatio.patch \
    file://0002-BaseTools-header.makefile-add-Wno-restrict.patch \
    file://0003-BaseTools-header.makefile-revert-gcc-8-Wno-xxx-optio.patch \
    file://0004-BaseTools-GenVtf-silence-false-stringop-overflow-war.patch \
"
