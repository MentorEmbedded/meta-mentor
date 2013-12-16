#FILESPATH .= ":${THISDIR}"
FILESEXTRAPATHS_prepend := "${THISDIR}:${THISDIR}/${PN}/${MACHINE}:"
SRC_URI	+= "file://files/fix_kernel_load_1.patch \
	    file://files/fix_kernel_load_2.patch \	    
	    file://defconfig"

