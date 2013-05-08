PR .= ".3"

USE_X11 = "${@base_contains("DISTRO_FEATURES", "x11", "yes", "no", d)}"
USE_DFB = "${@base_contains("DISTRO_FEATURES", "directfb", "yes", "no", d)}"

do_install_append () {
    if [ "${USE_X11}" = "yes" ]; then
        find ${D}${libdir} -name '*-dfb.so' -exec rm '{}' ';'
        find ${D}${libdir} -name '*-fb.so' -exec rm '{}' ';'
    else
        if [ "${USE_DFB}" = "yes" ]; then
            find ${D}${libdir} -name '*-x11.so' -exec rm '{}' ';'
            find ${D}${libdir} -name '*-fb.so' -exec rm '{}' ';'
        else
            # Regular framebuffer
            find ${D}${libdir} -name '*-x11.so' -exec rm '{}' ';'
            find ${D}${libdir} -name '*-dfb.so' -exec rm '{}' ';'
        fi
    fi

    # We'll only have one backend here so we rename it to generic name
    # and avoid rework in other packages, when possible
    rm ${D}${libdir}/libEGL.so ${D}${libdir}/libGAL.so \
       ${D}${libdir}/libVIVANTE.so

    rm -r ${D}${includedir}/GL

    renamed=
    for backend in x11 fb dfb; do
        for f in $(find ${D}${libdir} -name "*-$backend.so"); do
            if [ -n "$renamed" ] && [ "$renamed" != "$backend" ]; then
                bberror "More than one GPU backend is installed ($backend and $renamed)."
                exit 1
            fi

            renamed=$backend
            mv $f $(echo $f | sed "s,-$backend\.so,.so,g")
         done
    done
}

PACKAGES := "${@oe_filter_out('lib(egl|gal|vivante)-(fb|x11|common)', PACKAGES, d)}"
PACKAGES += "\
    libegl-mx6 libegl-mx6-dev libegl-mx6-dbg \
    libgal-mx6 libgal-mx6-dev libgal-mx6-dbg \
    libvivante-mx6 libvivante-mx6-dev libvivante-mx6-dbg \
"

FILES_libegl-mx6 = "${libdir}/libEGL${SOLIBS}"
FILES_libegl-mx6-dev = "${libdir}/libEGL${SOLIBSDEV}"
FILES_libegl-mx6-dbg = "${libdir}/.debug/libEGL${SOLIBS}"

FILES_libgal-mx6 = "${libdir}/libGAL${SOLIBS}"
FILES_libgal-mx6-dev = "${libdir}/libGAL${SOLIBSDEV}"
FILES_libgal-mx6-dbg = "${libdir}/.debug/libGAL${SOLIBS}"

FILES_libvivante-mx6 = "${libdir}/libVIVANTE${SOLIBS}"
FILES_libvivante-mx6-dev = "${libdir}/libVIVANTE${SOLIBSDEV}"
FILES_libvivante-mx6-dbg = "${libdir}/.debug/libVIVANTE${SOLIBS}"
