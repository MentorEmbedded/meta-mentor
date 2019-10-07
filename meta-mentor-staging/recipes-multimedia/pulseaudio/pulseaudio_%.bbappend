RDEPENDS_pulseaudio-module-systemd-login += "systemd"
RDEPENDS_pulseaudio-server += "\
    ${@bb.utils.contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluetooth-discover pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"
