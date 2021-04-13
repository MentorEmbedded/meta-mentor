FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Backport provided by the CB team
SRC_URI += "file://0001-gdbserver-handle-running-threads-in-qXfer-threads-re.patch"
