IMAGE_FEATURES .= "${@base_contains('COMBINED_FEATURES', 'alsa', ' tools-audio', '', d)}"
IMAGE_INSTALL += " quota"
