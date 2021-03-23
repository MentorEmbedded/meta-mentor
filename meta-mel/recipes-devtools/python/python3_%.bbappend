# Needed by patchinfo
PATCHINFO_PYTHONPATH = "${COMPONENTS_DIR}/${BUILD_ARCH}/python3-unidiff-native/${libdir}/python${PYTHON_MAJMIN}/site-packages"
DEPENDS_UNIDIFF = ""
DEPENDS_UNIDIFF_mel_class-target = "python3-unidiff-native:do_populate_sysroot"
do_archive_release_downloads[depends] += "${DEPENDS_UNIDIFF}"

# Write patch names and modified files to python3-patches.txt
python do_archive_release_downloads_append_mel_class-target () {
    import csv
    import json
    from collections import defaultdict
    from pathlib import Path

    sources_dir = Path(sources_dir)
    layerdir = d.getVar('LAYERDIR_mel')
    script = Path(layerdir).parent / 'scripts' / 'patchinfo'
    if not script.exists():
        bb.fatal('Expected {} script does not exist'.format(str(script)))
    
    python = d.getVar('PYTHON')
    env = os.environ.copy()
    env['PYTHONPATH'] = d.getVar('PATCHINFO_PYTHONPATH')

    patchinfos = []
    patches = [bb.fetch.decodeurl(u)[2] for u in src_patches(d)]
    for patch in patches:
        try:
            info, _ = bb.process.run([python, str(script), patch], cwd=sources_dir, env=env)
        except bb.process.ExecutionError as exc:
            bb.warn("Failed to get patchinfo for %s: %s" % (patch, exc))
            continue
        else:
            try:
                patchinfo = json.loads(info)
            except json.decoder.JSONDecodeError as exc:
                bb.warn("Failed to decode json from patchinfo for %s" % patch)
                continue
            else:
                if 'Filename' in patchinfo and 'Files' in patchinfo:
                    patchinfos.append(patchinfo)
                else:
                    bb.warn("Unexpected json contents for patchinfo for %s" % patch)
    
    with open(sources_dir / 'python3-patches.txt', 'w') as f:
        for patchinfo in patchinfos:
            bb.warn(repr(patchinfo))
            patch, files = patchinfo['Filename'], patchinfo['Files']
            f.write(patch + ':\n')
            for fn in files:
                f.write('  ' + fn + '\n')
}
