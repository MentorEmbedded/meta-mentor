# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SUMMARY = "Useful bits an pieces to make 96Boards more standard across the board"
HOMEPAGE = "https://github.com/96boards/96boards-tools"
SECTION = "devel"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRCREV = "52ad42bb74ba4b3fcece2483f0d496494d60715f"
SRC_URI = "git://github.com/96boards/96boards-tools;branch=master;protocol=https\
           file://resize-helper.sh.in"

S = "${WORKDIR}/git"

inherit systemd allarch update-rc.d

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0755 ${S}/*.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sbindir}
    install -m 0755 ${S}/resize-helper ${D}${sbindir}

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${S}/resize-helper.service ${D}${systemd_unitdir}/system
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/resize-helper.sh.in ${D}${sysconfdir}/init.d/resize-helper.sh
        sed -i -e "s:@bindir@:${bindir}:; s:@sbindir@:${sbindir}:; s:@sysconfdir@:${sysconfdir}:" \
            ${D}${sysconfdir}/init.d/resize-helper.sh
    fi
}

SYSTEMD_SERVICE_${PN} = "resize-helper.service"
RDEPENDS_${PN} += "e2fsprogs-resize2fs gptfdisk parted util-linux udev"

INITSCRIPT_NAME = "resize-helper.sh"
INITSCRIPT_PARAMS = "start 22 5 3 ."
