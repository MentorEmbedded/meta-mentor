FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Revert-aplay-fix-pcm_read-return-value.patch \
            file://alsa-utils-aplay-undo-hf-101.patch \
            file://alsa-utils-aplay-sigint-handling-corrected.patch \
           "

