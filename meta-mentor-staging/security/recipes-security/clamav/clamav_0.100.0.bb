SUMMARY = "ClamAV anti-virus utility for Unix - command-line interface"
DESCRIPTION = "ClamAV is an open source antivirus engine for detecting trojans, viruses, malware & other malicious threats."
HOMEPAGE = "http://www.clamav.net/index.html"
SECTION = "security"
LICENSE = "LGPL-2.1"

DEPENDS = "libtool db libmspack chrpath-replacement-native"

LIC_FILES_CHKSUM = "file://COPYING.LGPL;beginline=2;endline=3;md5=4b89c05acc71195e9a06edfa2fa7d092"

SRCREV = "a4c98c9f51a657587740982f2f0342c4014f550c"

# Include files from the meta-security files dir
FILESPATH_append = ":${@bb.utils.which('${BBPATH}', 'recipes-security/clamav/files')}"

SRC_URI = "git://github.com/Cisco-Talos/clamav-devel;branch=rel/${@'.'.join('${PV}'.split('.')[:-1])} \
    file://clamd.conf \
    file://freshclam.conf \
    file://volatiles.03_clamav \
    "

SRC_URI[md5sum] = "61b51a04619aeafd965892a53f86d192"
SRC_URI[sha256sum] = "167bd6a13e05ece326b968fdb539b05c2ffcfef6018a274a10aeda85c2c0027a"

S = "${WORKDIR}/git"

LEAD_SONAME = "libclamav.so"
SO_VER = "7.1.1"

EXTRANATIVEPATH += "chrpath-native"

inherit autotools pkgconfig useradd systemd

UID = "clamav"
GID = "clamav"

# Clamav has a built llvm version 2 but does not build with gcc 6.x,
# disable the internal one. This is a known issue
# If you want LLVM support, use meta-oe llvm3.3 to build for GCC 6.X,
# as defined below

CLAMAV_LLVM ?= "oellvm"
CLAMAV_LLVM_RELEASE ?= "5.0"

PACKAGECONFIG ?= "ncurses openssl bz2 zlib ${CLAMAV_LLVM}"
PACKAGECONFIG += " ${@bb.utils.contains("DISTRO_FEATURES", "ipv6", "ipv6", "", d)}"
PACKAGECONFIG += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"

PACKAGECONFIG[oellvm] = "--with-system-llvm --with-llvm-linking=dynamic --disable-llvm, ,llvm${CLAMAV_LLVM_RELEASE}"

PACKAGECONFIG[pcre] = "--with-pcre=${STAGING_LIBDIR},  --without-pcre, libpcre"
PACKAGECONFIG[xml] = "--with-xml=${STAGING_LIBDIR}/.., --with-xml=no, libxml2,"
PACKAGECONFIG[json] = "--with-libjson=${STAGING_LIBDIR}, --without-libjson, json,"
PACKAGECONFIG[curl] = "--with-libcurl=${STAGING_LIBDIR}, --without-libcurl, curl,"
PACKAGECONFIG[ipv6] = "--enable-ipv6, --disable-ipv6"
PACKAGECONFIG[openssl] = "--with-openssl=${STAGING_DIR_HOST}/usr, --without-openssl, openssl, openssl"
PACKAGECONFIG[zlib] = "--with-zlib=${STAGING_DIR_HOST}/usr --disable-zlib-vcheck , --without-zlib, zlib, "
PACKAGECONFIG[bz2] = "--with-libbz2-prefix=${STAGING_LIBDIR}/.., --without-libbz2-prefix, "
PACKAGECONFIG[ncurses] = "--with-libncurses-prefix=${STAGING_LIBDIR}/.., --without-libncurses-prefix, ncurses, "
PACKAGECONFIG[systemd] = "--with-systemdsystemunitdir=${systemd_unitdir}/system/, --without-systemdsystemunitdir, "

EXTRA_OECONF += " --with-user=${UID}  --with-group=${GID} \
            --without-libcheck-prefix --disable-unrar \
            --disable-mempool \
            --program-prefix='' \
            --disable-yara \
            --disable-rpath \
            "
EXTRA_AUTORECONF += "--exclude=gnu-configize"

do_configure_prepend () {
    rm -f ${S}/m4/libtool.m4 ${S}/m4/lt*.m4
}

do_install_append() {
    install -d ${D}/${sysconfdir}
    install -d ${D}/${localstatedir}/lib/clamav
    install -d ${D}${sysconfdir}/clamav ${D}${sysconfdir}/default/volatiles

    install -m 644 ${WORKDIR}/clamd.conf ${D}/${sysconfdir}
    install -m 644 ${WORKDIR}/freshclam.conf ${D}/${sysconfdir}
    install -m 0644 ${WORKDIR}/volatiles.03_clamav  ${D}${sysconfdir}/default/volatiles/volatiles.03_clamav
    sed -i -e 's#${STAGING_DIR_HOST}##g' ${D}${libdir}/pkgconfig/libclamav.pc
}

pkg_postinst_${PN} () {
    if [ -z "$D" ] && [ -e /etc/init.d/populate-volatile.sh ] ; then
        ${sysconfdir}/init.d/populate-volatile.sh update
    fi
    chown ${UID}:${GID} ${localstatedir}/lib/clamav
}

PACKAGES = "${PN} ${PN}-dev ${PN}-dbg ${PN}-daemon ${PN}-doc \
            ${PN}-clamdscan ${PN}-freshclam ${PN}-libclamav ${PN}-staticdev"

FILES_${PN} = "${bindir}/clambc ${bindir}/clamscan ${bindir}/clamsubmit \
                ${bindir}/*sigtool ${mandir}/man1/clambc* ${mandir}/man1/clamscan* \
                ${mandir}/man1/sigtool* ${mandir}/man1/clambsubmit*  \
                ${docdir}/clamav/* "

FILES_${PN}-clamdscan = " ${bindir}/clamdscan \
                        ${docdir}/clamdscan/* \
                        ${mandir}/man1/clamdscan* \
                        "

FILES_${PN}-daemon = "${bindir}/clamconf ${bindir}/clamdtop ${sbindir}/clamd \
                        ${mandir}/man1/clamconf* ${mandir}/man1/clamdtop* \
                        ${mandir}/man5/clamd*  ${mandir}/man8/clamd* \
                        ${sysconfdir}/clamd.conf* \
                        ${systemd_unitdir}/system/clamav-daemon* \
                        ${docdir}/clamav-daemon/*  ${sysconfdir}/clamav-daemon \
                        ${sysconfdir}/logcheck/ignore.d.server/clamav-daemon "

FILES_${PN}-freshclam = "${bindir}/freshclam \
                        ${sysconfdir}/freshclam.conf*  \
                        ${sysconfdir}/clamav ${sysconfdir}/default/volatiles \
                        ${localstatedir}/lib/clamav \
                        ${docdir}/${PN}-freshclam ${mandir}/man1/freshclam.* \
                        ${mandir}/man5/freshclam.conf.* \
                        ${systemd_unitdir}/system/clamav-freshclam*"

FILES_${PN}-dev += "${bindir}/clamav-config \
                    ${mandir}/man1/clamav-config.* \
                    ${docdir}/libclamav"

FILES_${PN}-libclamav = "${libdir}/libclamav.so* ${libdir}/libclammspack.so.*\
                          ${docdir}/libclamav/* "

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "--system ${UID}"
USERADD_PARAM_${PN} = "--system -g ${GID} --home-dir  \
    ${localstatedir}/spool/${BPN} \
    --no-create-home  --shell /bin/false ${BPN}"

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_PACKAGES = "${PN}-daemon ${PN}-freshclam"
SYSTEMD_SERVICE_${PN}-daemon = "clamav-daemon.service"
SYSTEMD_SERVICE_${PN}-freshclam = "clamav-freshclam.service"

RDEPENDS_${PN} += "openssl ncurses-libncurses libbz2 ncurses-libtinfo clamav-freshclam clamav-libclamav"
