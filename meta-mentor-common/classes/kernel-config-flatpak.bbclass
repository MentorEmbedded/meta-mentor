FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/namespaces.cfg') or '')}"

NAMESPACES_CFG = "${@bb.utils.contains('BBLAYERS', 'flatpak-layer', 'file://namespaces.cfg', '', d)}"
SRC_URI_append = " ${NAMESPACES_CFG}"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-flatpak.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
