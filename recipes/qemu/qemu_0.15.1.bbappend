SRC_URI += "file://cflags-separator.patch"
FILESPATH_prepend := "${THISDIR}:"

SDL_virtclass-native = "--disable-sdl"

# For our gl powered QEMU you need libGL and SDL headers
sdl_sanity_check () {
    libgl='no'
    libsdl='no'

    if [ "${SDL}" = "--disable-sdl" ]; then
        return
    fi

    test -e /usr/lib/libGL.so -a -e /usr/lib/libGLU.so && libgl='yes'
    test -e /usr/lib64/libGL.so -a -e /usr/lib64/libGLU.so && libgl='yes'
    test -e /usr/lib/*-linux-gnu/libGL.so -a -e /usr/lib/*-linux-gnu/libGLU.so && libgl='yes'

    test -e /usr/lib/pkgconfig/sdl.pc -o -e /usr/lib64/pkgconfig/sdl.pc -o -e /usr/include/SDL/SDL.h && libsdl='yes'


    if [ "$libsdl" != 'yes' -o "$libgl" != 'yes' ]; then
       echo "You need libGL.so and libGLU.so to exist in your library path and the development headers for SDL installed to build qemu-native.
       Ubuntu package names are: libgl1-mesa-dev, libglu1-mesa-dev and libsdl1.2-dev"
       exit 1;
    fi
}

do_configure_sb () {
    sdl_sanity_check

    # Handle distros such as CentOS 5 32-bit that do not have kvm support
    KVMOPTS="--disable-kvm"
    if [ "${PN}" != "qemu-native" ] || [ -f /usr/include/linux/kvm.h ] ; then
        KVMOPTS="--enable-kvm"
    fi

    ${S}/configure --prefix=${prefix} --sysconfdir=${sysconfdir} --disable-strip ${EXTRA_OECONF} $KVMOPTS
    test ! -e ${S}/target-i386/beginend_funcs.sh || chmod a+x ${S}/target-i386/beginend_funcs.sh
}

python () {
    d.setVar('do_configure', 'do_configure_sb')
}
