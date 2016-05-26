PACKAGECONFIG += "initrd"
PACKAGECONFIG[initrd] = ",,,"

PACKAGES_remove = "${@bb.utils.contains('PACKAGECONFIG', 'initrd', '', '${PN}-initrd', d)}"

do_install_append () {
    if ! ${@bb.utils.contains('PACKAGECONFIG', 'initrd', 'true', 'false', d)}; then
        rm -rf "${D}${libexecdir}"
    fi
}
