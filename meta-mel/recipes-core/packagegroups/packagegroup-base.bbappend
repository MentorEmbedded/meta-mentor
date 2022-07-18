# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

BLUEZ ?= "bluez5"
VIRTUAL-RUNTIME_bluetooth-stack ?= "${BLUEZ}"
VIRTUAL-RUNTIME_bluetooth-hw-support ?= ""

RDEPENDS:packagegroup-base-bluetooth:mel = "${VIRTUAL-RUNTIME_bluetooth-stack} ${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'pulseaudio pulseaudio-server', '', d)}"
RRECOMMENDS:packagegroup-base-bluetooth:mel = "${VIRTUAL-RUNTIME_bluetooth-hw-support}"

RDEPENDS:packagegroup-base-nfs:append:mel = " nfs-utils-client"
