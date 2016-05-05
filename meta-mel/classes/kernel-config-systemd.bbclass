FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/systemd.cfg') or '')}"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://systemd.cfg', '', d)}"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-systemd.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
