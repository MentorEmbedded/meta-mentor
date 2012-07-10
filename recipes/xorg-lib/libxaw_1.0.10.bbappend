PRINC := "${@int(PRINC) + 2}"

# Let libxaw7 files be captured by ${PN}
FILES_libxaw7 = ""

# Avoid renaming these based on libxaw7, as they're common to all the
# versioned libraries, it seems
DEBIANNAME_${PN}-dev = "${PN}-dev"
DEBIANNAME_${PN}-staticdev = "${PN}-staticdev"
DEBIANNAME_${PN}-dbg = "${PN}-dbg"
DEBIANNAME_${PN}-doc = "${PN}-doc"
