# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

RDEPENDS:pulseaudio-module-systemd-login:append:feature-mentor-staging = " systemd"
RDEPENDS:pulseaudio-server:append:feature-mentor-staging = "\
    ${@bb.utils.contains('PACKAGECONFIG', 'systemd', 'pulseaudio-module-systemd-login', '', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'bluez5', 'pulseaudio-module-bluetooth-discover pulseaudio-module-bluez5-discover pulseaudio-module-bluez5-device', '', d)} \
"
