EXTRA_OEMAKE += "'LD=${LD}'"

do_configure_prepend () {
    for makefile in "${S}/tools/perf/Makefile.perf" \
                    "${S}/tools/lib/api/Makefile"; do
        if [ -e "$makefile" ]; then
            sed -i 's,LD = $(CROSS_COMPILE)ld,#LD,' "$makefile"
        fi
    done
}

do_install_append () {
    sed -i -e "1s/python2/python/" "${D}${libexecdir}/perf-core/scripts/python/"*.py
}

FILES_${PN}-archive += "${libexecdir}/perf-core/perf-archive"
FILES_${PN}-tests += "${libexecdir}/perf-core/tests"
FILES_${PN}-perl += "${libexecdir}/perf-core/scripts/perl"
FILES_${PN}-python += "${libexecdir}/perf-core/scripts/python"
