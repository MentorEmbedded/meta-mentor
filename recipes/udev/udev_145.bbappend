PR .= ".1"

SRC_URI += "file://udev-166-v4l1-1.patch"
SRC_URI[md5sum] = "21c7cca07e934d59490184dd33c9a416"
SRC_URI[sha256sum] = "b511c3f597a1eaa026cec74a0d43d35f8f638d9df89666795db95cd1c65fa0ca"

LICENSE = "GPL-2.0+ & LGPL-2.1+"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
                    file://libudev/libudev.h;beginline=6;endline=9;md5=4d4026873e33acf43c17b4debb57eabf"
