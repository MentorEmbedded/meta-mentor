# We don't want modules in ~/.local being used in preference to those
# installed in the native sysroot, so disable user site support.
do_install_append () {
    sed -i -e 's,^\(ENABLE_USER_SITE = \).*,\1False,' ${D}${libdir}/python${PYTHON_MAJMIN}/site.py
}
