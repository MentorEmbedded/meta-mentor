FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://0001-powerpc-add-bss-plt-to-LDFLAGS.patch \
           "

RPROVIDES_${PN} += "u-boot"
