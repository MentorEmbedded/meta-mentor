PACKAGECONFIG = "wispr \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'systemd','systemd', '', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'wifi','wifi', '', d)} \
                   ${@bb.utils.contains('COMBINED_FEATURES', 'bluetooth','bluetooth', '', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', '3g','3g', '', d)} \
"
