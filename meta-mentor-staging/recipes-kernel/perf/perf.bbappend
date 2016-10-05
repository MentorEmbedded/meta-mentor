EXTRA_OEMAKE += "'LD=${LD}'"

do_configure_prepend () {
    for makefile in "${S}/tools/perf/Makefile.perf" \
                    "${S}/tools/lib/api/Makefile"; do
        if [ -e "$makefile" ]; then
            sed -i 's,LD = $(CROSS_COMPILE)ld,#LD,' "$makefile"
        fi
    done
}
