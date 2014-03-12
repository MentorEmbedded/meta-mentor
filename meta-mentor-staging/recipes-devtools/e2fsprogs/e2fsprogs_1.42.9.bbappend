do_configure_append() {
    sed -i '/@$(CHECK_MACRO_VERSION)/d' ${WORKDIR}/build/po/Makefile
}
