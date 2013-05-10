PRINC := "${@int(PRINC) + 3}"

# If the machine and distro both want alsa, then let the bluetooth task pull
# in the bluez libasound module as well.
RDEPENDS_packagegroup-base-bluetooth += "${@base_contains('COMBINED_FEATURES', 'alsa', 'libasound-module-bluez', '', d)}"
RDEPENDS_packagegroup-base-vfat += "dosfstools"

# We prefer rpcbind over portmap
RDEPENDS_packagegroup-base-nfs = "rpcbind"
