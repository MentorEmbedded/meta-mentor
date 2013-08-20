FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}"
SRC_URI_append = " file://lttng.cfg"

python () {
    if not oe.utils.inherits(d, 'kernel-yocto', 'cml1-config'):
        bb.fatal("kernel-config-lttng.bbclass requires kernel config fragments support. Please use kernel-yocto.bbclass or cml1-config.bbclass.")
}
