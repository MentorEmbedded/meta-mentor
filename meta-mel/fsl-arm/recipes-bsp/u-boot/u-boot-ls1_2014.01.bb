require recipes-bsp/u-boot/u-boot.inc
require recipes-bsp/u-boot/u-boot-ls1.inc

UBOOT_BASE_BINARY = "u-boot.bin"
PROVIDES = "${PN}"

SRCBRANCH = "LS1-dev"
SRC_URI = "git://git.freescale.com/layerscape/ls1021a/u-boot.git;protocol=git;branch=${SRCBRANCH} \
           file://0001-ls1021atwr-Enable-support-for-SD-write-to-NOR-flash.patch"

SRCREV = "50d684801cd05ed6b77d52d1ca9ed00fefeac469"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-${SRCBRANCH}"

PACKAGES += "${PN}-images"
FILES_${PN}-images += "/boot"

ALLOW_EMPTY_${PN} = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(ls102xa)"

UBOOT_CONFIGS = "ls1021atwr_nor_config,u-boot-ls1-nor\
                 ls1021atwr_sdcard_config,u-boot-ls1-sd"

do_compile () {
 unset LDFLAGS
    unset CFLAGS
    unset CPPFLAGS   
        # Create directory to store images built, so that distclean wont remove them!
        mkdir -p ${WORKDIR}/deploy-uboot-ls1

    if [ "x${UBOOT_CONFIGS}" = "x" ]; then
        UBOOT_CONFIGS=${UBOOT_CONFIGS},${UBOOT_CONFIGS}
    fi

    for config in ${UBOOT_CONFIGS}; do
        uboot_type="$(echo "$config" | cut -d, -f1)"
        config="$(echo "$config" | cut -d, -f2)"

        echo "going to build ${uboot_type} for ${config}."
        oe_runmake distclean
        oe_runmake ${uboot_type}
        oe_runmake ${UBOOT_MAKE_TARGET}
        make CROSS_COMPILE="${HOST_PREFIX}" HOSTSTRIP=true tools env
        cp ${S}/${UBOOT_BASE_BINARY} ${WORKDIR}/deploy-uboot-ls1/${config}.${UBOOT_SUFFIX}
    done
    mv ${S}/u-boot-with-spl-pbl.bin ${S}/u-boot.bin
    cp ${S}/${UBOOT_BASE_BINARY} ${WORKDIR}/deploy-uboot-ls1/${config}.${UBOOT_SUFFIX}
}


do_install () {
    install -d ${D}/boot

    for config in ${UBOOT_CONFIGS}; do
        uboot_type="$(echo "$config" | cut -d, -f2)"
        install ${WORKDIR}/deploy-uboot-ls1/${uboot_type}.${UBOOT_SUFFIX} ${D}/boot/${uboot_type}-${PV}-${PR}.${UBOOT_SUFFIX}
        ln -sf ${uboot_type}-${PV}-${PR}.${UBOOT_SUFFIX} ${D}/boot/${uboot_type}.${UBOOT_SUFFIX}
    done
}

do_deploy () {
    install -d ${DEPLOYDIR}
    cd ${DEPLOYDIR}

    for config in ${UBOOT_CONFIGS}; do
        uboot_type="$(echo "$config" | cut -d, -f2)"
        install ${WORKDIR}/deploy-uboot-ls1/${uboot_type}.${UBOOT_SUFFIX} ${DEPLOYDIR}/${uboot_type}-${PV}-${PR}.${UBOOT_SUFFIX}
        rm -f ${uboot_type}.${UBOOT_SUFFIX} ${uboot_type}-${MACHINE}.${UBOOT_SUFFIX}
        ln -sf ${uboot_type}-${PV}-${PR}.${UBOOT_SUFFIX} ${uboot_type}.${UBOOT_SUFFIX}
        ln -sf ${uboot_type}-${PV}-${PR}.${UBOOT_SUFFIX} ${uboot_type}-${MACHINE}.${UBOOT_SUFFIX}
    done
}
