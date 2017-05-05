FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://0001-python3-correct-the-multilib-support.patch"
