PR .= ".1"

do_compile() {
        # Fix to avoid recursive substitution of path
        sed -i -e "s|\([ \"\']\+\)/usr/include|\1${STAGING_INCDIR}|g" ext/Errno/Errno_pm.PL
        sed -i -e "s|\([ \"\']\+\)/usr/include|\1${STAGING_INCDIR}|g" cpan/Compress-Raw-Zlib/config.in
        sed -i -e 's|/usr/lib|""|g' cpan/Compress-Raw-Zlib/config.in
        sed -i -e 's|SYSROOTLIB|${STAGING_LIBDIR}|g' cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm

        cd Cross
        oe_runmake perl LD="${CCLD} ${LDFLAGS}"
}
