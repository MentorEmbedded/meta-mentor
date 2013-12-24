FILESPATH_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://dbus-ptest-fix-test-suite.patch"

EXTRA_OECONF  += "--disable-asserts --disable-checks"

