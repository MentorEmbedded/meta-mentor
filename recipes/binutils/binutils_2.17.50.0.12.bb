require recipes-devtools/binutils/binutils.inc

DEFAULT_PREFERENCE = "-1"

LICENSE = "GPLv2 & LGPLv2"
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
    ${KERNELORG_MIRROR}/pub/linux/devel/binutils/binutils-${PV}.tar.bz2 \
    file://binutils-2.16.91.0.6-objcopy-rename-errorcode.patch \
    file://110-arm-eabi-conf.patch \
"

SRC_URI[md5sum] = "6f3e83399b965d70008860f697c50ec2"
SRC_URI[sha256sum] = "7360808266f72aed6fda41735242fb9f1b6dd3307cd6e283a646932438eaa929"

DEPENDS += "texinfo-native"

EXTRA_OECONF += "\
    --with-sysroot=/ \
    --enable-install-libbfd \
    --enable-shared \
"

do_configure () {
	# Fix for issues when system's texinfo version >= 4.10
	# (See https://bugzilla.redhat.com/show_bug.cgi?id=345621)
	sed -i -e "s@egrep 'texinfo.*'@egrep 'texinfo[^0-9]*([1-3][0-9]|4\.[4-9]|4.[1-9][0-9]+|[5-9])'@" '${S}/configure'
	oe_runconf
}

do_install_append () {
	rm -rf ${D}${prefix}/${TARGET_SYS}/lib
}
