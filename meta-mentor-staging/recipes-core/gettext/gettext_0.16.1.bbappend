# Anyone inheriting gettext will have both gettext-native and gettext
# available, and we don't want to use older macros from the target gettext in
# a non-gplv3 build, so kill them and let dependent recipes rely on
# gettext-native.

SYSROOT_PREPROCESS_FUNCS += "remove_sysroot_m4_macros"

remove_sysroot_m4_macros () {
    rm -r "${SYSROOT_DESTDIR}${datadir}/aclocal"
}
