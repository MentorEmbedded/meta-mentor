PR .= ".1"

do_compile() {
        # regenerate platform specific files, because they depend on system headers
        cd Lib/plat-linux2
        include=${STAGING_INCDIR} ${STAGING_BINDIR_NATIVE}/python-native/python \
                ${S}/Tools/scripts/h2py.py -i '(u_long)' \
                ${STAGING_INCDIR}/dlfcn.h \
                ${STAGING_INCDIR}/linux/cdrom.h \
                ${STAGING_INCDIR}/netinet/in.h \
                ${STAGING_INCDIR}/sys/types.h
        sed -e 's,${STAGING_DIR_HOST},,g' -i *.py
        cd -

        # remove hardcoded ccache, see http://bugs.openembedded.net/show_bug.cgi?id=4144
        sed -i -e s,ccache\ ,'$(CCACHE) ', Makefile

        # remove any bogus LD_LIBRARY_PATH
        sed -i -e s,RUNSHARED=.*,RUNSHARED=, Makefile

        if [ ! -f Makefile.orig ]; then
                install -m 0644 Makefile Makefile.orig
        fi
        sed -i -e 's#^LDFLAGS=.*#LDFLAGS=${LDFLAGS} -L. -L${STAGING_LIBDIR}#g' \
                -e 's,libdir=${libdir},libdir=${STAGING_LIBDIR},g' \
                -e 's,libexecdir=${libexecdir},libexecdir=${STAGING_DIR_HOST}${libexecdir},g' \
                -e 's,^LIBDIR=.*,LIBDIR=${STAGING_LIBDIR},g' \
                -e 's,includedir=${includedir},includedir=${STAGING_INCDIR},g' \
                -e 's,^INCLUDEDIR=.*,INCLUDE=${STAGING_INCDIR},g' \
                -e 's,^CONFINCLUDEDIR=.*,CONFINCLUDE=${STAGING_INCDIR},g' \
                Makefile
        # save copy of it now, because if we do it in do_install and
        # then call do_install twice we get Makefile.orig == Makefile.sysroot
        install -m 0644 Makefile Makefile.sysroot

        export CROSS_COMPILE="${TARGET_PREFIX}"
        export PYTHONBUILDDIR="${S}"

        oe_runmake HOSTPGEN=${STAGING_BINDIR_NATIVE}/python-native/pgen \
                HOSTPYTHON=${STAGING_BINDIR_NATIVE}/python-native/python \
                STAGING_LIBDIR=${STAGING_LIBDIR} \
                STAGING_INCDIR=${STAGING_INCDIR} \
                STAGING_BASELIBDIR=${STAGING_BASELIBDIR} \
                BUILD_SYS=${BUILD_SYS} HOST_SYS=${HOST_SYS} \
                OPT="${CFLAGS}"
}
