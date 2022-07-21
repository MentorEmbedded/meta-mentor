# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

RDEPENDS:packagegroup-base-bluetooth:append:mel = "${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'pulseaudio pulseaudio-server', '', d)}"

RDEPENDS:packagegroup-base-nfs:append:mel = " nfs-utils-client"
