do_install_append() {
    if [ "${PACKAGE_DEBUG_SPLIT_STYLE}" == "debug-file-directory"  ]; then

        install -d ${D}${libdir}/debug

        for dir in ${libdir}/gconv; do
            install -d ${D}${libdir}/debug$dir
            mv ${D}$dir/.debug/*.debug  ${D}${libdir}/debug$dir
            rm -rf ${D}$dir/.debug
        done
    fi
}
