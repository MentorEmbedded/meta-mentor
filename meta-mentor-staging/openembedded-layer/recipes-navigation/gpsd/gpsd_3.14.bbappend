# gpsd uses libbluetooth, which is compatible between bluez4 & bluez5
PACKAGECONFIG ??= "qt ${@base_contains('DISTRO_FEATURES', 'bluetooth', 'bluez', '', d)}"
PACKAGECONFIG[bluez] = "bluez='true',bluez='false',${BLUEZ}"
