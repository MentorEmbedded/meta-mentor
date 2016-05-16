FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0002-only-build-GLX-demos-if-needed.patch"
PACKAGECONFIG[glx] = "--enable-glx-demos,--disable-glx-demos"
PACKAGECONFIG += "glx"
