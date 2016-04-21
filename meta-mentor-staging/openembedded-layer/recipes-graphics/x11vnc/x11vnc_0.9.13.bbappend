do_prepare_sources () {
    sed -i -e '/^# libtool.m4/q' acinclude.m4
}
do_patch[postfuncs] += "do_prepare_sources"
