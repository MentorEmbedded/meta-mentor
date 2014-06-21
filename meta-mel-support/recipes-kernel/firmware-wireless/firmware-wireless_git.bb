SUMMARY = "Firmware files for wireless chips for use with Linux kernel"
SECTION = "kernel"

LICENSE = "\
    Firmware-atheros & \
    Firmware-broadcom & \
    Firmware-cw1200 & \
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
    file://atheros/LICENSE;md5=670a25baf80964a6a286bfa4d981aef4 \
    file://broadcom/LICENSE;md5=8cba1397cda6386db37210439a0da3eb \
    file://cw1200/LICENSE;md5=f0f770864e7a8444a5c5aa9d12a3a7ed \
    file://intelwimax/LICENSE;md5=14b901969e23c41881327c0d9e4b7d36 \
    file://libertas/LICENSE;md5=d934c5881815c89f0ed946179315fa35 \
    file://orinoco/LICENSE;md5=af0133de6b4a9b2522defd5f188afd31 \
    file://ralink/LICENSE;md5=d0ac64cc96774fed46eb5a772a658652 \
    file://realtek/LICENSE;md5=4f9d5ca75b4e819b2afa39ee8a8496e9 \
    file://rsi/LICENSE;md5=84bfadbcb40f0f3fd3967aafd77c85f7 \
    file://ti-connectivity/LICENSE;md5=8b81af85c4472aea6355d742b472572c \
    file://via_vt6656/LICENSE;md5=e4159694cba42d4377a912e78a6e850f \
    file://carl9170/COPYRIGHT;md5=b0e5b5cb9edb5794f96103f3598518ac \
    file://carl9170/LICENSE;md5=751419260aa954499f7abaabaa882bbe \
"


SRCREV = "c2c3df64df50d826d7649e03fbbe84ea99e5dbc8"
PV = "0.0+git${SRCPV}"

SRC_URI = "git://github.com/MentorEmbedded/firmware-wireless;protocol=https"
S = "${WORKDIR}/git"

inherit allarch update-alternatives

do_compile() {
	:
}

do_install() {
	install -d  ${D}${base_libdir}/firmware/
	for dir in */; do
	    cp -rf $dir/* ${D}${base_libdir}/firmware/
	done
	rm -f ${D}${base_libdir}/firmware/LICENSE* ${D}${base_libdir}/firmware/COPYRIGHT \
	      ${D}${base_libdir}/firmware/defines

	# Avoid Makefile to be deplyed
	rm -f ${D}${base_libdir}/firmware/Makefile

	# Remove carl9170 firmware sources
	rm -rf ${D}${base_libdir}/firmware/carl9170fw

	# Libertas sd8686
	ln -sf libertas/sd8686_v9.bin ${D}${base_libdir}/firmware/sd8686.bin
	ln -sf libertas/sd8686_v9_helper.bin ${D}${base_libdir}/firmware/sd8686_helper.bin

	# fixup wl12xx location, after 2.6.37 the kernel searches a different location for it
	( cd ${D}${base_libdir}/firmware ; ln -sf ti-connectivity/* . )

	chmod -R g-ws ${D}
}

FILES_${PN} += "${base_libdir}/firmware/*"
