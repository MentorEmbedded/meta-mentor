# These are binaries, we don't care about missing build deps
WARN_QA_remove = "build-deps"
ERROR_QA_remove = "build-deps"

# Silence remaining warnings
WARN_QA_remove = "file-rdeps"
ERROR_QA_remove = "file-rdeps"

# already-stripped is in INSANE_SKIP to quiet the packaging warning, but
# sysroot binaries are also stripped, emitting the same message, and that does
# not obey INSANE_SKIP at this time.
INHIBIT_SYSROOT_STRIP = "1"

# The no-x11 recipe excludes these, but they're still needed by the shared
# libs, so dep on them to resolve shlibs for rdeps
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'libxfixes libxext libdrm', '', d)}"

do_install_append () {
    # Correct ownership on prebuilt binaries copied into ${D}
    chown -R root:root "${D}"
}
