FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://0001-Use-LD-and-obey-LDFLAGS.patch \
    file://0002-Allow-override-of-the-uname-s-for-cross-compilation.patch \
"

do_unpack[postfuncs] += "dos2unix"

dos2unix () {
    cr="$(printf '\r')"
    for f in make/*/Makefile; do
        tr -d "$cr" <"$f" >"$f.new" && \
            mv "$f.new" "$f"
    done
}

LIBEBML_OS = "Unknown"
LIBEBML_OS_linux = "Linux"
LIBEBML_OS_darwin = "Darwin"
LIBEBML_OS_mingw32 = "Windows"

EXTRA_OEMAKE = "\
    'TARGET_OS=${LIBEBML_OS}' \
    \
    'CXX=${CXX}' \
    'LD=${CXX}' \
    'AR=${AR}' \
    'RANLIB=${RANLIB}' \
    \
    'DEBUGFLAGS=' \
    'CPPFLAGS=${CPPFLAGS}' \
    'CXXFLAGS=${CXXFLAGS}' \
    'LDFLAGS=${LDFLAGS}' \
    \
    'prefix=${prefix}' \
    'libdir=${libdir}' \
    'includedir=${includedir}/ebml' \
"

do_compile () {
    oe_runmake -C make/linux
}
