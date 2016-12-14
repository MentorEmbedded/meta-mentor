FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fcntl-fix-the-time-def-to-use-time_t.patch"

