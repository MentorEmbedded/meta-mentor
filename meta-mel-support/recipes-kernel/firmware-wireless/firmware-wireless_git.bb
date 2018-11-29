SUMMARY = "Firmware files for wireless chips for use with Linux kernel"
SECTION = "kernel"

LICENSE = "\
    Firmware-qualcommAthos_ath10k & \
    Firmware-atheros & \
    Firmware-broadcom & \
    Firmware-cw1200 & \
    Firmware-carl9170 & \
    Firmware-intelwimax & \
    Firmware-libertas & \
    Firmware-orinoco & \
    Firmware-ralink & \
    Firmware-realtek & \
    Firmware-rsi & \
    Firmware-ti-connectivity & \
    Firmware-via_vt6656 & \
    GPL-2.0 \
"

LIC_FILES_CHKSUM = "\
    file://LICENSE.QualcommAtheros_ath10k;md5=cb42b686ee5f5cb890275e4321db60a8 \
    file://LICENSE.atheros;md5=670a25baf80964a6a286bfa4d981aef4 \
    file://LICENSE.broadcom;md5=8cba1397cda6386db37210439a0da3eb \
    file://LICENSE.cw1200;md5=f0f770864e7a8444a5c5aa9d12a3a7ed \
    file://LICENSE.intelwimax;md5=14b901969e23c41881327c0d9e4b7d36 \
    file://LICENSE.libertas;md5=d934c5881815c89f0ed946179315fa35 \
    file://LICENSE.orinoco;md5=af0133de6b4a9b2522defd5f188afd31 \
    file://LICENSE.ralink;md5=d0ac64cc96774fed46eb5a772a658652 \
    file://LICENSE.realtek;md5=4f9d5ca75b4e819b2afa39ee8a8496e9 \
    file://LICENSE.rsi;md5=84bfadbcb40f0f3fd3967aafd77c85f7 \
    file://LICENSE.ti-connectivity;md5=8b81af85c4472aea6355d742b472572c \
    file://LICENSE.via_vt6656;md5=e4159694cba42d4377a912e78a6e850f \
    file://LICENSE.carl9170;md5=751419260aa954499f7abaabaa882bbe \
"

NO_GENERIC_LICENSE[Firmware-qualcommAthos_ath10k] = "LICENSE.QualcommAtheros_ath10k"
NO_GENERIC_LICENSE[Firmware-atheros] = "LICENSE.atheros"
NO_GENERIC_LICENSE[Firmware-broadcom] = "LICENSE.broadcom"
NO_GENERIC_LICENSE[Firmware-cw1200] = "LICENSE.cw1200"
NO_GENERIC_LICENSE[Firmware-intelwimax] = "LICENSE.intelwimax"
NO_GENERIC_LICENSE[Firmware-libertas] = "LICENSE.libertas"
NO_GENERIC_LICENSE[Firmware-orinoco] = "LICENSE.orinoco"
NO_GENERIC_LICENSE[Firmware-ralink] = "LICENSE.ralink"
NO_GENERIC_LICENSE[Firmware-realtek] = "LICENSE.realtek"
NO_GENERIC_LICENSE[Firmware-rsi] = "LICENSE.rsi"
NO_GENERIC_LICENSE[Firmware-ti-connectivity] = "LICENSE.ti-connectivity"
NO_GENERIC_LICENSE[Firmware-via_vt6656] = "LICENSE.via_vt6656"
NO_GENERIC_LICENSE[Firmware-carl9170] = "LICENSE.carl9170"

SRCREV = "4b939aff1262372a789fd85a0785ca3ab4da8834"
PV = "0.0+git${SRCPV}"

SRC_URI = "git://github.com/MentorEmbedded/firmware-wireless;protocol=https"
S = "${WORKDIR}/git"

inherit allarch update-alternatives

hack_around_do_populate_lic_limitations () {
    for license in ${@' '.join(d.getVarFlags('NO_GENERIC_LICENSE').values())}; do
        n="$(echo "$license" | sed 's,\([^.]*\)\.\(.*\),\2/\1,')"
        cp -f "${S}/$n" "${S}/$license"
    done
}
hack_around_do_populate_lic_limitations[vardeps] += "NO_GENERIC_LICENSE"
do_unpack[postfuncs] += "hack_around_do_populate_lic_limitations"

do_compile() {
	:
}

do_install() {
	install -d  ${D}${nonarch_base_libdir}/firmware/
	for dir in */; do
	    cp -rf $dir/* ${D}${nonarch_base_libdir}/firmware/
	done
	rm -f ${D}${nonarch_base_libdir}/firmware/LICENSE* ${D}${nonarch_base_libdir}/firmware/COPYRIGHT \
	      ${D}${nonarch_base_libdir}/firmware/defines

	# Avoid Makefile to be deplyed
	rm -f ${D}${nonarch_base_libdir}/firmware/Makefile

	# Remove carl9170 firmware sources
	rm -rf ${D}${nonarch_base_libdir}/firmware/carl9170fw

	# Libertas sd8686
	ln -sf libertas/sd8686_v9.bin ${D}${nonarch_base_libdir}/firmware/sd8686.bin
	ln -sf libertas/sd8686_v9_helper.bin ${D}${nonarch_base_libdir}/firmware/sd8686_helper.bin

	# fixup wl12xx location, after 2.6.37 the kernel searches a different location for it
	( cd ${D}${nonarch_base_libdir}/firmware ; ln -sf ti-connectivity/* . )

	chmod -R g-ws ${D}
}

FILES_${PN} += "${nonarch_base_libdir}/firmware/*"
