B = "${WORKDIR}/build"
EXTRA_OEMAKE += "\
    'srcdir=${S}' \
    -f ${S}/GNUmakefile \
"

do_compile_prepend () {
    sed -i -e 's# fbgs# \$(srcdir)/fbgs#; s#-Ijpeg#-I\$(srcdir)/jpeg#; s# jpeg/# \$(srcdir)/jpeg/#' ${S}/GNUmakefile
}
