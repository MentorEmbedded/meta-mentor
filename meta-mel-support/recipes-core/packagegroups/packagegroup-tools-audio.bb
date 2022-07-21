# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

DESCRIPTION = "Package group for audio support."

inherit packagegroup

# alsa-utils-alsactl and alsa-utils-alsamixer is coming from alsa base packagegroup if alsa is added in MACHINE_FEATURES.
RDEPENDS:${PN} += "\
    alsa-utils-amixer \
    alsa-utils-aplay \
"
