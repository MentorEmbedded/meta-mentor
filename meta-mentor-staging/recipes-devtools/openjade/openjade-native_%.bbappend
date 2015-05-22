EXTRA_OECONF += "--enable-static --disable-shared"

# override do_install
do_install() {
        # Refer to http://www.linuxfromscratch.org/blfs/view/stable/pst/openjade.html
        # for details.
        install -d ${D}${bindir}
        install -m 0755 ${S}/jade/openjade ${D}${bindir}/openjade
        ln -sf openjade ${D}${bindir}/jade

        install -d ${D}${datadir}/sgml/openjade-${PV}
        install -m 644 dsssl/catalog ${D}${datadir}/sgml/openjade-${PV}
        install -m 644 dsssl/*.dtd ${D}${datadir}/sgml/openjade-${PV}
        install -m 644 dsssl/*.dsl ${D}${datadir}/sgml/openjade-${PV}
        install -m 644 dsssl/*.sgm ${D}${datadir}/sgml/openjade-${PV}

        install -d ${datadir}/sgml/openjade-${PV}
        install -m 644 dsssl/catalog ${datadir}/sgml/openjade-${PV}/catalog

        install -d ${D}${sysconfdir}/sgml
        echo "CATALOG ${datadir}/sgml/openjade-${PV}/catalog" > \
                ${D}${sysconfdir}/sgml/openjade-${PV}.cat
}
