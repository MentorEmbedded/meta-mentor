BLUEZ ?= "bluez5"
VIRTUAL-RUNTIME_bluetooth-stack ?= "${BLUEZ}"
VIRTUAL-RUNTIME_bluetooth-hw-support ?= ""

RDEPENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-stack} ${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'pulseaudio pulseaudio-server', '', d)}"
RRECOMMENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-hw-support}"

RDEPENDS_packagegroup-base-nfs_append_mel = " nfs-utils"
