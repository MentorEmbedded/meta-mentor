REL_PERLLIB = "${@os.path.relpath(libdir, bindir)}/perl"

do_install_append_class-nativesdk () {
    mv "${D}${bindir}/perl.real" "${D}${bindir}/perl"
    create_wrapper "${D}${bindir}/perl" \
        PERL5LIB='$PERL5LIB:`dirname $realpath`/${REL_PERLLIB}:`dirname $realpath`/${REL_PERLLIB}/${PV}'
}
