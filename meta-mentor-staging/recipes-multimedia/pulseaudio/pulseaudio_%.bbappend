RDEPENDS_pulseaudio-module-systemd-login_append_feature-mentor-staging = " systemd"
RDEPENDS_pulseaudio-server_append_feature-mentor-staging = "\
    ${@bb.utils.contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluetooth-discover pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"
