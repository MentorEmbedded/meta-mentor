FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
           file://0001-configure.ac-Do-not-use-readlink-when-cross-compilin.patch \
          "
