LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
                    file://libudev/libudev.h;beginline=6;endline=9;md5=4d4026873e33acf43c17b4debb57eabf"

RPROVIDES_${PN} = "hotplug"

PR = "r12"

SRC_URI = "${KERNELORG_MIRROR}/linux/utils/kernel/hotplug/udev-${PV}.tar.gz \
           file://enable-gudev.patch \
           file://udev-166-v4l1-1.patch \
	   file://run.rules \
	   "
SRC_URI[md5sum] = "21c7cca07e934d59490184dd33c9a416"
SRC_URI[sha256sum] = "b511c3f597a1eaa026cec74a0d43d35f8f638d9df89666795db95cd1c65fa0ca"

require udev-old.inc

INITSCRIPT_PARAMS = "start 03 S ."

FILES_${PN} += "${base_libdir}/udev/*"
FILES_${PN}-dbg += "${base_libdir}/udev/.debug"
UDEV_EXTRAS = "extras/firmware/ extras/scsi_id/ extras/volume_id/"

EXTRA_OECONF = "--with-udev-prefix= --disable-extras --disable-introspection"

DEPENDS += "glib-2.0"

do_install () {
	install -d ${D}${sbindir}
	oe_runmake 'DESTDIR=${D}' INSTALL=install install
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/udev
	install -m 0755 ${WORKDIR}/udev-cache ${D}${sysconfdir}/init.d/udev-cache

	install -d ${D}${sysconfdir}/udev/rules.d/

	cp ${S}/rules/rules.d/* ${D}${sysconfdir}/udev/rules.d/
	cp ${S}/rules/packages/* ${D}${sysconfdir}/udev/rules.d/
	install -m 0644 ${WORKDIR}/local.rules         ${D}${sysconfdir}/udev/rules.d/local.rules
	#install -m 0644 ${WORKDIR}/permissions.rules   ${D}${sysconfdir}/udev/rules.d/permissions.rules
	#install -m 0644 ${WORKDIR}/run.rules          ${D}${sysconfdir}/udev/rules.d/run.rules
	#install -m 0644 ${WORKDIR}/udev.rules          ${D}${sysconfdir}/udev/rules.d/udev.rules
	#install -m 0644 ${WORKDIR}/links.conf          ${D}${sysconfdir}/udev/links.conf
	#if [ "${UDEV_DEVFS_RULES}" = "1" ]; then
	#	install -m 0644 ${WORKDIR}/devfs-udev.rules ${D}${sysconfdir}/udev/rules.d/devfs-udev.rules
	#fi

	# Remove some default rules that don't work well on embedded devices
	#rm ${D}${sysconfdir}/udev/rules.d/60-persistent-input.rules
	#rm ${D}${sysconfdir}/udev/rules.d/60-persistent-storage.rules
	#rm ${D}${sysconfdir}/udev/rules.d/60-persistent-storage-tape.rules
}

FILESPATH .= ":${@base_set_filespath(['${COREBASE}/meta/recipes-core/udev/udev'], d)}"
