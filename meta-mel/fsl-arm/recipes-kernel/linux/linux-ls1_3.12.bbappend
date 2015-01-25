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
        merge = 'merge_config.sh -m "${S}/.config" ${FRAGMENTS}\n'
        cfg = ''.join([before, indent, line, indent, merge, after])
        d.setVar('do_configure', cfg)
}

# Enable lttng config
FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which("${BBPATH}", 'files/lttng.cfg') or '')}"
SRC_URI += "file://lttng.cfg"

# Enable systemd config
SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"
