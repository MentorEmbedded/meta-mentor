SUMMARY = "Useful bits an pieces to make 96Boards more standard across the board"
HOMEPAGE = "https://github.com/96boards/96boards-tools"
SECTION = "devel"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRCREV = "193f355823d9dc38f370759153ac950a2833b0e2"
SRC_URI = "git://github.com/96boards/96boards-tools;branch=master;protocol=https"
SRC_URI_append_imx6ulevk-mel = " file://0001-resize-helper.service-allow-udevd-to-process-device-.patch"

S = "${WORKDIR}/git"

inherit systemd allarch

do_compile () {
    # The parted version we're using doesn't want this argument
    sed -i -e "/PARTED/s/ Yes / /" ${S}/resize-helper
}

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0755 ${S}/*.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/resize-helper.service ${D}${systemd_unitdir}/system

    install -d ${D}${sbindir}
    install -m 0755 ${S}/resize-helper ${D}${sbindir}
}

SYSTEMD_SERVICE_${PN} = "resize-helper.service"
RDEPENDS_${PN} += "e2fsprogs-resize2fs gptfdisk parted util-linux udev"
