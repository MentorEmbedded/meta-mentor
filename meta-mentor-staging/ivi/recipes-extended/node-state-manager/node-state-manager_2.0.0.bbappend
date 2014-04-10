FILESEXTRAPATHS_prepend := "${THISDIR}:"

# Move the non-symlink .so libs into the main package
FILES_${PN} += "${libdir}/*${SOLIBSDEV}"
FILES_SOLIBSDEV = ""
