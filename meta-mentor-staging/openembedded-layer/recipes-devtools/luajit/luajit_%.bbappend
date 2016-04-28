# The lua makefiles expect the TARGET_SYS to be from uname -s
# Values: Windows, Linux, Darwin, iOS, SunOS, PS3, GNU/kFreeBSD
LUA_TARGET_OS="${@'${TARGET_OS}'[0].upper() + '${TARGET_OS}'[1:]}"
LUA_TARGET_OS_mingw32 = "Windows"

# We don't want the lua buildsystem's compiler optimizations, or its
# stripping, and we don't want it to pick up CFLAGS or LDFLAGS, as those apply
# to both host and target compiles
EXTRA_OEMAKE = "\
    Q= E='@:' \
    CCOPT= CCOPT_x86= CFLAGS= LDFLAGS= TARGET_STRIP='@:' \
    \
    'TARGET_SYS=${LUA_TARGET_OS}' \
    \
    'CC=${CC}' \
    'TARGET_AR=${AR} rcus' \
    'TARGET_STRIP=${STRIP}' \
    'HOST_CFLAGS=${BUILD_CFLAGS}' \
    'HOST_LDFLAGS=${BUILD_LDFLAGS}' \
    \
    'PREFIX=${prefix}' \
    'MULTILIB=${baselib}' \
"

EXTRA_OEMAKE_append = "\
    CROSS= \
    'HOST_CC=${BUILD_CC}' \
    'TARGET_CFLAGS=${CFLAGS}' \
    'TARGET_LDFLAGS=${LDFLAGS}' \
    'TARGET_SHLDFLAGS=${LDFLAGS}' \
"

# There's INSTALL_LIB and INSTALL_SHARE also, but the lua binary hardcodes the
# '/share' and '/' + LUA_MULTILIB paths, so we don't want to break those
# expectations.
EXTRA_OEMAKEINST = "\
    'DESTDIR=${D}' \
    'INSTALL_BIN=${D}${bindir}' \
    'INSTALL_INC=${D}${includedir}/luajit-$(MAJVER).$(MINVER)' \
    'INSTALL_MAN=${D}${mandir}/man1' \
"
do_install () {
    oe_runmake ${EXTRA_OEMAKEINST} install
    rmdir ${D}${datadir}/lua/5.* \
          ${D}${datadir}/lua \
          ${D}${libdir}/lua/5.* \
          ${D}${libdir}/lua
}

# See the comment for EXTRA_OEMAKEINST. This is needed to ensure the hardcoded
# paths are packaged regardless of what the libdir and datadir paths are.
FILES_${PN} += "${prefix}/${baselib} ${prefix}/share"
