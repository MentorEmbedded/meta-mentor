FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/encryptfs.cfg') or '')}"

ENCRYPTFS_CFG = "${@bb.utils.contains('USER_FEATURES', 'encrypted-fs', 'file://encryptfs.cfg', '', d)}"
SRC_URI_append = " ${ENCRYPTFS_CFG}"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-encryptfs.bbclass.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
