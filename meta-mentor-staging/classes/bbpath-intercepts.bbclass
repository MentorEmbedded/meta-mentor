# Assemble a recipe-local postinst-intecepts directory by gathering intercepts
# from BBPATH. This lets layers override intercepts.
POSTINST_INTERCEPTS_DIR = "${WORKDIR}/bbpath-intercepts"
POSTINST_INTERCEPTS_PATHS = "${@':'.join('%s/postinst-intercepts' % p for p in '${BBPATH}'.split(':'))}:${COREBASE}/scripts/postinst-intercepts"
POSTINST_INTERCEPTS = "${@find_intercepts(d)}"

def find_intercepts(d):
    intercepts = {}
    search_paths = []
    paths = d.getVar('POSTINST_INTERCEPTS_PATHS').split(':')
    overrides = (':' + d.getVar('FILESOVERRIDES')).split(':')
    for p in paths:
        if not os.path.isdir(p):
            continue
        for o in overrides:
            op = os.path.join(p, o)
            if os.path.isdir(op):
                search_paths.append(op)

    for p in search_paths:
        for s in os.listdir(p):
            if s not in intercepts:
                f = os.path.join(p, s)
                if os.path.isfile(f):
                    intercepts[s] = f
    return ' '.join(intercepts.values())

python assemble_intercepts () {
    intercepts = d.getVar('POSTINST_INTERCEPTS', True).split()
    bb.debug(1, 'Collected intercepts:\n%s' % ''.join('  %s\n' % i for i in intercepts))
    intercepts_dir = d.getVar('POSTINST_INTERCEPTS_DIR', True)
    bb.utils.mkdirhier(intercepts_dir)
    bb.process.run(['cp'] + intercepts + [intercepts_dir])
}
assemble_intercepts[cleandirs] += "${POSTINST_INTERCEPTS_DIR}"

do_rootfs[prefuncs] += "assemble_intercepts"
do_rootfs[file-checksums] += "${@' '.join('%s:True' % f for f in '${POSTINST_INTERCEPTS}'.split())}"
do_populate_sdk[prefuncs] += "assemble_intercepts"
do_populate_sdk[file-checksums] += "${@' '.join('%s:True' % f for f in '${POSTINST_INTERCEPTS}'.split())}"
