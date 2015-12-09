require recipes-graphics/mesa/mesa.inc

SRC_URI = "ftp://ftp.freedesktop.org/pub/mesa/${PV}/mesa-${PV}.tar.xz"

SRC_URI[md5sum] = "c92c37200009eceaab4898119f82e358"
SRC_URI[sha256sum] = "40201bf7fc6fa12a6d9edfe870b41eb4dd6669154e3c42c48a96f70805f5483d"

#because we cannot rely on the fact that all apps will use pkgconfig,
#make eglplatform.h independent of MESA_EGL_NO_X11_HEADER
do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'egl', 'true', 'false', d)}; then
        sed -i -e 's/^#if defined(MESA_EGL_NO_X11_HEADERS)$/#if defined(MESA_EGL_NO_X11_HEADERS) || ${@bb.utils.contains('PACKAGECONFIG', 'x11', '0', '1', d)}/' ${D}${includedir}/EGL/eglplatform.h
    fi
}

# EGL from Mesa 10.6.3 isn't functional with GCC-5.2 on ARMv7 platforms
COMPATIBLE_MACHINE = "(ls1021atwr|zc702-zynq7-mel|zedboard-zynq7-mel)"

# Adding GLES3 headers to libgles2-mesa-dev package
FILES_libgles2-mesa-dev += "${includedir}/GLES3"
