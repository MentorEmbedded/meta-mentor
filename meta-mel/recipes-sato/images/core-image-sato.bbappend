IMAGE_FEATURES_append_mel = "${@bb.utils.contains('COMBINED_FEATURES', 'alsa', ' tools-audio', '', d)}"
IMAGE_INSTALL_append_mel = " quota"
