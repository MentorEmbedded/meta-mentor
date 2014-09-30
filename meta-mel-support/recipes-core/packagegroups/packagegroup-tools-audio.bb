DESCRIPTION = "Package group for audio support."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit packagegroup

# alsa-utils-alsactl and alsa-utils-alsamixer is coming from alsa base packagegroup if alsa is added in MACHINE_FEATURES.
RDEPENDS_${PN} += "\
    alsa-utils-amixer \
    alsa-utils-aplay \
"
