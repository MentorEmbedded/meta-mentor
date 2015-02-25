FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
LIC_FILES_CHKSUM = "file://COPYING;md5=5cec2aa8e94c6fb833af19e94304b233"

SRC_URI = "file://skmm-host.tgz"

SRC_URI[md5sum] = "f5a449933cd3de9a756e09756bd4faf9"
SRC_URI[sha256sum] = "b496918f9f4be8d602920f596aad093afb9c822a69bdd5922245c9657f99af08"

S= "${WORKDIR}/${PN}"

do_install () {
        cp -r ${S}/etc ${D}/
        cp -r ${S}/lib ${D}/
        cp -r ${S}/usr ${D}/
}

do_compile () {
}

FILES_${PN} += "/etc"
FILES_${PN} += "/lib"
FILES_${PN} += "/usr"
