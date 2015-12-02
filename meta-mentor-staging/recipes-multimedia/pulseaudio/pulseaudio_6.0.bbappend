RDEPENDS_pulseaudio-module-systemd-login += "systemd"
RDEPENDS_pulseaudio-server += "\
    ${@base_contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@base_contains('PACKAGECONFIG', 'bluez4', 'pulseaudio-module-bluetooth-discover pulseaudio-module-bluez4-discover', '', d)} \
    ${@base_contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluetooth-discover pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"
