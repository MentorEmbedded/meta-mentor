require recipes-bsp/u-boot/u-boot.inc
require recipes-bsp/u-boot/u-boot-ls1.inc

SRCBRANCH = "LS1-dev"
SRC_URI = "git://git.freescale.com/layerscape/ls1021a/u-boot.git;protocol=git;branch=${SRCBRANCH}"
SRCREV = "50d684801cd05ed6b77d52d1ca9ed00fefeac469"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-${SRCBRANCH}"

PACKAGES += "${PN}-images"
FILES_${PN}-images += "/boot"

ALLOW_EMPTY_${PN} = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(ls102xa)"

