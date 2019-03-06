FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/debugging.cfg') or '')}"
SRC_URI_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'mel-debugging', 'file://debugging.cfg', '', d)}"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-debugging.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
