FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Fix duration issues for auto-termination
SRC_URI += "file://0001-Revert-aplay-fix-pcm_read-return-value.patch"
