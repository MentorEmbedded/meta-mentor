FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
           file://selinux-example.sh \
           file://selinux-demo.tar.gz \
           "

do_compile_append() {
        cd ${S};
        ${CC} ${LDFLAGS} -o hello-world hello-world.c
        ${CC} ${LDFLAGS} -o stack-smash stack-smash.c
}

do_install_append() {
        install -d ${D}${datadir}/examples/selinux/
        install -m 0777 ${S}/selinux-example.sh ${D}${datadir}/examples/selinux/
        install -m 0755 ${S}/hello-world ${D}${datadir}/examples/selinux/
        install -m 0755 ${S}/stack-smash ${D}${datadir}/examples/selinux/
}
