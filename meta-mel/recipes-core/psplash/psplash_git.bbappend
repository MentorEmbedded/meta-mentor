FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI_append_mel = " ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '\
                   file://psplash-quit.service \
                   file://psplash-start.service \
                   file://psplash-final.service \
                   ', '', d)}"

# Change background color and splash image with no progress bar
SRC_URI_append_mel = " file://0001-psplash-disable-progress-bar-for-systemd.patch \
		  file://0001-psplash-config-enable-fullscreen-image.patch \
		  file://0001-plash-colors.h-color-change.patch \
		 "
# Update to latest version of psplash
SRCREV_mel = "5b3c1cc28f5abdc2c33830150b48b278cc4f7bca"

SPLASH_IMAGES_mel = "file://mel.png;outsuffix=default"

inherit systemd
SYSTEMD_SERVICE_${PN}_mel = "psplash-start.service psplash-quit.service psplash-final.service"
SYSTEMD_AUTO_ENABLE ?= "enable"

do_install_append_mel() {
        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
                install -d ${D}${systemd_unitdir}/system/
                install -m 0644 ${WORKDIR}/psplash-quit.service ${D}${systemd_unitdir}/system
                install -m 0644 ${WORKDIR}/psplash-start.service ${D}${systemd_unitdir}/system
                install -m 0644 ${WORKDIR}/psplash-final.service ${D}${systemd_unitdir}/system
        fi
}
