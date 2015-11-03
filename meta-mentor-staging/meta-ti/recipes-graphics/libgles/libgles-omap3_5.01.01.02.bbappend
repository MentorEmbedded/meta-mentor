# These are binaries, we don't care about missing build deps
WARN_QA_remove = "build-deps"
ERROR_QA_remove = "build-deps"

# already-stripped is in INSANE_SKIP to quiet the packaging warning, but
# sysroot binaries are also stripped, emitting the same message, and that does
# not obey INSANE_SKIP at this time.
INHIBIT_SYSROOT_STRIP = "1"

do_install_append () {
    # Correct ownership on prebuilt binaries copied into ${D}
    chown -R root:root "${D}"
}
