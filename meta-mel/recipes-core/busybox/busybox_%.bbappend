FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

DEPENDS += "${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPLv3', bb.utils.contains('IMAGE_FEATURES', 'security-selinux', 'libselinux', '', d), '', d)}"

CHCON_CFG = "${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPLv3', bb.utils.contains('IMAGE_FEATURES', 'security-selinux', 'file://chcon.cfg', '', d), '', d)}"

# fancy-head.cfg is enabled so we have head -c, which we need for our tracing
# scripts with lttng
SRC_URI_append_mel = "\
    file://setsid.cfg \
    file://resize.cfg \
    file://fancy-head.cfg \
	file://pidof.cfg \
	file://top.cfg \
	${CHCON_CFG} \
"
