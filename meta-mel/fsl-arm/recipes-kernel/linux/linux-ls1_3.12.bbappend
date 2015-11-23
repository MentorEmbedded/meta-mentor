# Hack to merge config fragments for kernels inheriting meta-fsl-arm's
# fsl-kernel-localversion.bbclass.
DEPENDS += "kern-tools-native"

FRAGMENTS = "${@' '.join(s for s in src_patches(d, True) if s.endswith('cfg'))}"

python () {
    import re
    cfg = d.getVar('do_configure', False)
    try:
        before, indent, line, after = re.split('(\n\s+)(sed -e "\${CONF_SED_SCRIPT}".*)\n', cfg)
    except ValueError:
        return
    else:
        merge = 'merge_config.sh -m "${B}/.config" ${FRAGMENTS}\n'
        cfg = ''.join([before, indent, line, indent, merge, after])
        d.setVar('do_configure', cfg)
}

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "\
    file://unionfs-2.6_for_3.12.26.patch \
    file://0001-serial-fsl_lpuart-Remove-unneeded-check-for-res.patch \
    file://0002-serial-fsl_lpuart-Remove-unneeded-registration-messa.patch \
    file://0003-tty-serial-fsl_lpuart-clear-receive-flag-on-FIFO-flu.patch \
    file://0001-module.c-change-the-load_module-optimization-to-0.patch \
    \
    file://kgdb.cfg \
    file://configs.cfg \
    file://autofs.cfg \
    file://filesystems.cfg \
    file://ipv6.cfg \
    file://novgarb.cfg \
"

# GCC-5.x updates to fix the build issue
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "\
	file://0001-ftrace-Make-CALLER_ADDRx-macros-more-generic.patch \
	file://0002-arm-ftrace-fix-ftrace_return_addr-to-ftrace_return_a.patch \
	file://0003-ARM-8158-1-LLVMLinux-use-static-inline-in-ARM-ftrace.patch \
	file://0004-ARM-LLVMLinux-Change-extern-inline-to-static-inline-.patch \
	file://0005-i2c-imx-Fix-format-warning-for-dev_dbg.patch \
	file://0006-crypto-caam-fix-RNG-buffer-cache-alignment.patch \
	file://0009-Input-lifebook-use-static-inline-instead-of-inline-i.patch \
	file://0010-Input-trackpoint-use-static-inline-instead-of-inline.patch \
	file://0011-Input-fsp_detect-use-static-inline-instead-of-inline.patch \
	file://0001-kernel-use-the-gnu89-standard-explicitly.patch \
"

# Enable lttng config
FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which("${BBPATH}", 'files/lttng.cfg') or '')}"
SRC_URI += "file://lttng.cfg"

# Enable systemd config
SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"

SRC_URI += "${@bb.utils.contains('BBFILE_COLLECTIONS', 'mel-iot', " ${6LOWPAN_PATCHES}", '', d)}"

6LOWPAN_PATCHES = "\
	file://0001-6lowpan-add-Werners-atusb-driver.patch \
	file://0002-6lowpan-add-frag-information-struct.patch \
	file://0003-6lowpan-fix-fragmentation-on-sending-side.patch \
	file://0004-net-add-ieee802154_6lowpan-namespace.patch \
	file://0005-6lowpan-handling-6lowpan-fragmentation-via-inet_frag.patch \
	file://0006-6lowpan-handle-return-value-on-lowpan_process_data.patch \
	file://0007-6lowpan-fix-udp-nullpointer-dereferencing.patch \
	file://0008-6lowpan-fix-udp-compress-ordering.patch \
	file://0009-6lowpan-fix-udp-byte-ordering.patch \
	file://0010-6lowpan-add-udp-warning-for-elided-checksum.patch \
	file://0011-6lowpan-udp-use-lowpan_fetch_skb-function.patch \
	file://0012-6lowpan-udp-use-subtraction-on-both-conditions.patch \
	file://0013-net-6lowpan-fix-lowpan_header_create-non-compression.patch \
	file://0014-ieee802154-space-prohibited-before-that-close-parent.patch \
	file://0015-6lowpan-switch-to-standard-IPV6_MIN_MTU-value.patch \
	file://0016-net-introduce-new-macro-net_get_random_once.patch \
	file://0017-net-fix-build-warnings-because-of-net_get_random_onc.patch \
	file://0018-net-make-net_get_random_once-irq-safe.patch \
	file://6lowpan.cfg \
	"
