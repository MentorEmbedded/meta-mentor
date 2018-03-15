do_install_append() {
    # we end up with some weird pollution from cross-toolchain, remove them
    rm -f ${D}${bindir}/${TARGET_SYS}-${TARGET_PREFIX}*
}
