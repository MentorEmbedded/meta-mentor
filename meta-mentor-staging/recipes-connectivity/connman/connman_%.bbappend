# Ensure that an empty resolv.conf exists before connman writes to it. This
# way we have it in place in the read-only /, and we can bind mount over it.
do_install_append () {
    install -d ${D}${sysconfdir}
    touch ${D}${sysconfdir}/resolv.conf
}
