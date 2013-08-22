SUMMARY = "Common CA certificates"
DESCRIPTION = "This package includes PEM files of CA certificates to allow \
SSL-based applications to check for the authenticity of SSL connections."
HOMEPAGE = "http://packages.debian.org/sid/ca-certificates"
SECTION = "misc"
LICENSE = "GPL-2.0+ & MPL-2.0"
LIC_FILES_CHKSUM = "file://debian/copyright;md5=d8fc4ed45f01c31c87c9b496d4babcae"

# This is needed to ensure we can run the postinst at image creation time
DEPENDS = "ca-certificates-native"
DEPENDS_class-native = ""

# tag: debian/20130610
SRCREV = "9f3c12784eaee1e2b005a23ce8b5c38e1e851404"

SRC_URI = "git://anonscm.debian.org/collab-maint/ca-certificates.git \
           file://0001-update-ca-certificates-remove-c-rehash.patch \
           file://0002-update-ca-certificates-use-SYSROOT.patch \
           file://default-sysroot.patch \
           file://sbindir.patch"
S = "${WORKDIR}/git"

inherit allarch

EXTRA_OEMAKE = "\
    'CERTSDIR=${datadir}/ca-certificates' \
    'SBINDIR=${sbindir}' \
"

do_install () {
    install -d ${D}${datadir}/ca-certificates \
               ${D}${sysconfdir}/ssl/certs \
               ${D}${sysconfdir}/ca-certificates/update.d
    oe_runmake 'DESTDIR=${D}' install

    install -d ${D}${mandir}/man8
    install -m 0644 sbin/update-ca-certificates.8 ${D}${mandir}/man8/

    install -d ${D}${sysconfdir}
    {
        echo "# Lines starting with # will be ignored"
        echo "# Lines starting with ! will remove certificate on next update"
        echo "#"
        find ${D}${datadir}/ca-certificates -type f -name '*.crt' | \
            sed 's,^${D}${datadir}/ca-certificates/,,'
    } >${D}${sysconfdir}/ca-certificates.conf
}

do_install_append_class-target () {
    sed -i -e 's,/etc/,${sysconfdir}/,' \
           -e 's,/usr/share/,${datadir}/,' \
           -e 's,/usr/local,${prefix}/local,' \
        ${D}${sbindir}/update-ca-certificates \
        ${D}${mandir}/man8/update-ca-certificates.8
}

pkg_postinst_${PN} () {
    SYSROOT="$D" update-ca-certificates
}

CONFFILES_${PN} += "${sysconfdir}/ca-certificates.conf"

# Postinsts don't seem to be run for nativesdk packages when populating SDKs.
CONFFILES_${PN}_append_class-nativesdk = " ${sysconfdir}/ssl/certs/ca-certificates.crt"
do_install_append_class-nativesdk () {
    SYSROOT="${D}${SDKPATHNATIVE}" update-ca-certificates
}

BBCLASSEXTEND += "native nativesdk"
