FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Interrupt streaming via CTRL-C
SRC_URI += "file://0001-alsa-utils-interrupt-streaming-via-signal.patch"
