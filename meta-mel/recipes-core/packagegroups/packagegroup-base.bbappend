RDEPENDS_packagegroup-base-vfat_append_mel = " dosfstools"
RDEPENDS_packagegroup-base-ipv6_append_mel = " dhcp-client"
RDEPENDS_packagegroup-base-nfs_append_mel = " nfs-utils"

RDEPENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-stack} pulseaudio pulseaudio-server"
RRECOMMENDS_packagegroup-base-bluetooth_mel = "${VIRTUAL-RUNTIME_bluetooth-hw-support}"
