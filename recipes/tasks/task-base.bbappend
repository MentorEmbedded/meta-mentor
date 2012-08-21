PRINC := "${@int(PRINC) + 1}"

# If the machine and distro both want alsa, then let the bluetooth task pull
# in the bluez libasound module as well.
RDEPENDS_task-base-bluetooth += "${@base_contains('COMBINED_FEATURES', 'alsa', 'libasound-module-bluez', '', d)}"
