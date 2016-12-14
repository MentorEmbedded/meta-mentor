# Assemble a recipe-local postinst-intecepts directory by gathering intercepts
# from BBPATH. This lets layers override intercepts.
POSTINST_INTERCEPTS_DIR = "${WORKDIR}/bbpath-intercepts"
POSTINST_INTERCEPTS_PATHS = "${@':'.join('%s/postinst-intercepts' % p for p in '${BBPATH}'.split(':'))}:${COREBASE}/scripts/postinst-intercepts"
POSTINST_INTERCEPTS = "${@find_intercepts(d)}"

def find_intercepts(d):
    intercepts = {}
    for p in d.getVar('POSTINST_INTERCEPTS_PATHS', True).split(':'):
        if os.path.isdir(p):
            for s in os.listdir(p):
                if s not in intercepts:
                    intercepts[s] = os.path.join(p, s)
    return ' '.join(intercepts.values())

python assemble_intercepts () {
    intercepts = d.getVar('POSTINST_INTERCEPTS', True).split()
    bb.debug(1, 'Collected intercepts:\n%s' % ('  %s\n' % i for i in intercepts))
    intercepts_dir = d.getVar('POSTINST_INTERCEPTS_DIR', True)
    bb.utils.mkdirhier(intercepts_dir)
    bb.process.run(['cp'] + intercepts + [intercepts_dir])
}
assemble_intercepts[cleandirs] += "${POSTINST_INTERCEPTS_DIR}"

do_rootfs[prefuncs] += "assemble_intercepts"
do_rootfs[file-checksums] += "${@' '.join('%s:True' % f for f in '${POSTINST_INTERCEPTS}'.split())}"
