# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

require recipes-devtools/binutils/binutils.inc

DEFAULT_PREFERENCE = "-1"
PR = "r1"

LICENSE = "GPL-2.0-only & LGPL-2.0-only"
LIC_FILES_CHKSUM = "\
    file://src-release;endline=17;md5=4830a9ef968f3b18dd5e9f2c00db2d35 \
    file://COPYING;md5=59530bdf33659b29e73d4adb9f9f6552 \
    file://COPYING.LIB;md5=9f604d8a4f8e74f4f5140845a21b6674 \
    file://gas/COPYING;md5=77a30f8e524e777bf2078eb691ef3dd6 \
    file://include/COPYING;md5=59530bdf33659b29e73d4adb9f9f6552 \
    file://libiberty/COPYING.LIB;md5=a916467b91076e631dd8edb7424769c7 \
    file://bfd/COPYING;md5=77a30f8e524e777bf2078eb691ef3dd6 \
"
SRC_URI = "\
    ${KERNELORG_MIRROR}/linux/devel/binutils/binutils-${PV}.tar.bz2 \
    file://binutils-2.16.91.0.6-objcopy-rename-errorcode.patch \
    file://110-arm-eabi-conf.patch \
"

SRC_URI[md5sum] = "6f3e83399b965d70008860f697c50ec2"
SRC_URI[sha256sum] = "7360808266f72aed6fda41735242fb9f1b6dd3307cd6e283a646932438eaa929"

DEPENDS += "flex texinfo-native"

#
# we need chrpath > 0.14 and some distros like centos 7 still have older chrpath
#
DEPENDS:append:class-target = " chrpath-replacement-native"
EXTRANATIVEPATH:append:class-target = " chrpath-native"

EXTRA_OECONF += "\
    --with-sysroot=/ \
    --enable-install-libbfd \
    --enable-shared \
"
# FIXME: hack way to get it obeying LDFLAGS for GNU_HASH warnings
TARGET_CC_ARCH += "${LDFLAGS}"

# Disable texinfo usage due to incompatibilities with different versions
EXTRA_OEMAKE += "'MAKEINFO=true'"

do_configure () {
	oe_runconf
}

do_install:append () {
	rm -rf ${D}${prefix}/${TARGET_SYS}/lib
}

# Kill redundant rpaths
do_install:append:class-target () {
	for i in ${D}${bindir}/*; do
		chrpath -d "$i"
	done
}

# This version doesn't provide these
USE_ALTERNATIVES_FOR:remove = "ld.bfd elfedit ld.gold dwp"

python () {
    '''This binutils version has no elfedit.'''
    compilefunc = d.getVar('do_compile', False).replace('chrpath -d ${B}/binutils/elfedit', '')
    d.setVar('do_compile', compilefunc)
}
