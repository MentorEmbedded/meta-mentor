FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_mel = " \
    file://0001-Ensure-filesystems-are-still-mounted-when-consolekit.patch \
"
