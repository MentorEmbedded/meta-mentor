require recipes-core/udev/udev.inc

DEFAULT_PREFERENCE = "-1"
PR = "r18"

LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
                    file://libudev/COPYING;md5=a6f89e2100d9b6cdffcea4f398e37343 \
                    file://extras/gudev/COPYING;md5=a6f89e2100d9b6cdffcea4f398e37343"

SRC_URI := "${@oe_filter_out('.*keyboard_force_release', SRC_URI, d)}"
SRC_URI += "\
    file://udev-166-v4l1-1.patch \
    file://include_resource.patch \
"
SRC_URI[md5sum] = "fddac2d54761ea34865af9467377ca9f"
SRC_URI[sha256sum] = "c12e66280b5e1465f6587a8cfa47d7405c4caa7e52ce5dd13478d04f6ec05e5c"

do_unpack[postfuncs] += "adjust_init_paths"
do_unpack[vardeps] += "adjust_init_paths"

adjust_init_paths () {
    sed -i -e 's,/lib/udev/udevd,${base_sbindir}/udevd,' \
           -e 's,/usr/bin/udevadm,${base_sbindir}/udevadm,' \
        ${WORKDIR}/init ${WORKDIR}/udev-cache
}

FILESPATH .= ":${@base_set_filespath(['${COREBASE}/meta/recipes-core/udev/udev'], d)}"
