# These are binaries, we don't care about missing build deps
WARN_QA_remove = "build-deps"
ERROR_QA_remove = "build-deps"

# already-stripped is in INSANE_SKIP to quiet the packaging warning, but
# sysroot binaries are also stripped, emitting the same message, and that does
# not obey INSANE_SKIP at this time.
INHIBIT_SYSROOT_STRIP = "1"

# Add missing rdeps
RDEPENDS_${PN}-es3 += "libxfixes"
RDEPENDS_${PN}-es5 += "libxfixes"
RDEPENDS_${PN}-es6 += "libxfixes"
RDEPENDS_${PN}-es8 += "libxfixes"
RDEPENDS_${PN}-es9 += "libxfixes"

# libsrv_um.so is in PRIVATE_LIBS, so shlibs cannot find it for determination
# of file-rdeps
INSANE_SKIP_${PN}-es3 += "file-rdeps"
INSANE_SKIP_${PN}-es5 += "file-rdeps"
INSANE_SKIP_${PN}-es6 += "file-rdeps"
INSANE_SKIP_${PN}-es8 += "file-rdeps"
INSANE_SKIP_${PN}-es9 += "file-rdeps"

# libGLES_CM.so is in PRIVATE_LIBS, so shlibs cannot find it for determination
# of file-rdeps
INSANE_SKIP_${PN}-rawdemos += "file-rdeps"

# libpvr2d.so is in PRIVATE_LIBS, so shlibs cannot find it for determination
# of file-rdeps
INSANE_SKIP_${PN}-tests += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl-es3 += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl-es5 += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl-es6 += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl-es8 += "file-rdeps"
INSANE_SKIP_${PN}-flipwsegl-es9 += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl-es3 += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl-es5 += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl-es6 += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl-es8 += "file-rdeps"
INSANE_SKIP_${PN}-frontwsegl-es9 += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl-es3 += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl-es5 += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl-es6 += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl-es8 += "file-rdeps"
INSANE_SKIP_${PN}-linuxfbwsegl-es9 += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl-es3 += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl-es5 += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl-es6 += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl-es8 += "file-rdeps"
INSANE_SKIP_${PN}-blitwsegl-es9 += "file-rdeps"

do_install_append () {
    # Correct ownership on prebuilt binaries copied into ${D}
    chown -R root:root "${D}"
}
