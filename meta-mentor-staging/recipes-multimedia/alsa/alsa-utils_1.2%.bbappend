FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${PN}:"

# Interrupt streaming via CTRL-C
SRC_URI_append_feature-mentor-staging = " file://0001-alsa-utils-interrupt-streaming-via-signal.patch"
