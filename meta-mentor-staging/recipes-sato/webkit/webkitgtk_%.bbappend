# Link fails due to memory exhaustion, so disable debug info to reduce the
# memory footprint
DEBUG_FLAGS_remove = "-g"

FILES_${PN}-dbg += "${libdir}/webkit2gtk-4.0/injected-bundle/.debug \
		    ${libdir}/webkitgtk/webkit2gtk-4.0/.debug/* \
                   "
