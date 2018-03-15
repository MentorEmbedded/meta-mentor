# Assemble a recipe-local postinst-intecepts directory by gathering intercepts
# from BBPATH. This lets layers override intercepts.
POSTINST_INTERCEPTS_DIR = "${WORKDIR}/bbpath-intercepts"
POSTINST_INTERCEPTS_PATHS = "${@':'.join('%s/postinst-intercepts' % p for p in '${BBPATH}'.split(':'))}:${COREBASE}/scripts/postinst-intercepts"

def which_wild(pathname, path=None, mode=os.F_OK, *, reverse=False, candidates=False):
    import glob

    paths = (path or os.environ.get('PATH', os.defpath)).split(':')
    if reverse:
        paths.reverse()

    seen, files = set(), []
    for index, element in enumerate(paths):
        if not os.path.isabs(element):
            element = os.path.abspath(element)

        candidate = os.path.join(element, pathname)
        globbed = glob.glob(candidate)
        if globbed:
            for found_path in sorted(globbed):
                if not os.access(found_path, mode):
                    continue
                rel = os.path.relpath(found_path, element)
                if rel not in seen:
                    seen.add(rel)
                    if candidates:
                        files.append((found_path, [os.path.join(p, rel) for p in paths[:index+1]]))
                    else:
                        files.append(found_path)

    return files

def find_intercepts(d):
    intercepts = {}
    search_paths = []
    paths = d.getVar('POSTINST_INTERCEPTS_PATHS').split(':')
    overrides = (':' + d.getVar('FILESOVERRIDES')).split(':') + ['']
    search_paths = [os.path.join(p, op) for p in paths for op in overrides]
    searched = which_wild('*', ':'.join(search_paths), candidates=True)
    files, chksums = [], []
    for pathname, candidates in searched:
        if os.path.isfile(pathname):
            files.append(pathname)
            chksums.append('%s:True' % pathname)
            chksums.extend('%s:False' % c for c in candidates[:-1])

    d.setVar('POSTINST_INTERCEPT_CHECKSUMS', ' '.join(chksums))
    d.setVar('POSTINST_INTERCEPTS', ' '.join(files))

python assemble_intercepts () {
    intercepts = d.getVar('POSTINST_INTERCEPTS', True).split()
    bb.debug(1, 'Collected intercepts:\n%s' % ''.join('  %s\n' % i for i in intercepts))
    intercepts_dir = d.getVar('POSTINST_INTERCEPTS_DIR', True)
    bb.utils.mkdirhier(intercepts_dir)
    bb.process.run(['cp'] + intercepts + [intercepts_dir])
}
assemble_intercepts[cleandirs] += "${POSTINST_INTERCEPTS_DIR}"
do_rootfs[prefuncs] += "assemble_intercepts"
do_populate_sdk[prefuncs] += "assemble_intercepts"
do_rootfs[file-checksums] += "${POSTINST_INTERCEPT_CHECKSUMS}"
do_populate_sdk[file-checksums] += "${POSTINST_INTERCEPT_CHECKSUMS}"

python () {
    find_intercepts(d)
}
