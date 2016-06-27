def src_config_fragments(d):
    sources = src_patches(d, True)
    return [s for s in sources if s.endswith('.cfg')]

DELTA_KERNEL_DEFCONFIG += "${@' '.join(src_config_fragments(d))}"

SRC_URI_append = " file://nbd.cfg \
                   file://autofs.cfg \
                   file://lttng.cfg \
                   file://autofs.cfg \
                   file://ext4.cfg \
                   file://0001-kernel-module-change-the-optimization-level-of-load_.patch \
                   file://0002-kernel-module.c-Remove-optimization-for-complete_for.patch \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/lttng.cfg') or '')}"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"
