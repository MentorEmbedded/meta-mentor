FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI += "file://byte-order-byteswap-h.patch \
            file://fix-undefined-O_CLOEXEC.patch"
