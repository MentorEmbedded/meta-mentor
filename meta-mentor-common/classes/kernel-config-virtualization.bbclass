FILESEXTRAPATHS_prepend = "${@os.path.dirname(bb.utils.which(BBPATH, 'files/docker.cfg') or '')}:"

VIRTUALIZATION_CFGS = "${@bb.utils.contains('BBLAYERS', 'virtualization-layer', 'file://docker.cfg \
                                                                                 file://ebtables.cfg \
                                                                                 file://lxc.cfg \
                                                                                 file://vswitch.cfg \
                                                                                 file://xt-checksum.cfg \
                                                                                 ', '', d)}"

SRC_URI_append = " ${VIRTUALIZATION_CFGS}"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-virtualization.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
