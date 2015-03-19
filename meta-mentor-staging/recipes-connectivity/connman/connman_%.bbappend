# Ensure that an empty resolv.conf exists before connman writes to it. This
# way we have it in place in the read-only /, and we can bind mount over it.
do_install_append () {
    install -d ${D}${sysconfdir}
    touch ${D}${sysconfdir}/resolv.conf
}

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-connman-implement-network-interface-management-techn.patch"