FILESEXTRAPATHS_append = ":${@':'.join('%s/../scripts/release:%s/../scripts' % (l, l) for l in '${BBPATH}'.split(':'))}"
MEL_SCRIPTS_FILES = "mel-checkout version-sort setup-mel setup-workspace setup-ubuntu setup-rh"
SRC_URI += "${@' '.join(uninative_urls(d)) if 'mel_downloads' in '${RELEASE_ARTIFACTS}'.split() else ''}"
SRC_URI += "${@' '.join('file://%s' % s for s in d.getVar('MEL_SCRIPTS_FILES').split())}"

inherit layerdirs

ARCHIVE_RELEASE_VERSION ?= "${DISTRO_VERSION}"
SCRIPTS_VERSION ?= "0"
MANIFEST_NAME ?= "${DISTRO}-${ARCHIVE_RELEASE_VERSION}-${MACHINE}"
EXTRA_MANIFEST_NAME ?= "${DISTRO}-${ARCHIVE_RELEASE_VERSION}"
SCRIPTS_ARTIFACT_NAME ?= "${DISTRO}-scripts-${DISTRO_VERSION}.${SCRIPTS_VERSION}"
BSPFILES_INSTALL_PATH = "${MACHINE}/${ARCHIVE_RELEASE_VERSION}"
GET_REMOTES_HOOK ?= ""

# Layers which get their own extra manifests, rather than being included in
# the main one. How they're combined or shipped from there is up to our
# release scripts.
INDIVIDUAL_MANIFEST_LAYERS ?= ""
FORKED_REPOS ?= ""
PUBLIC_REPOS ?= "${FORKED_REPOS}"

RELEASE_EXCLUDED_LAYERNAMES ?= ""

ARCHIVE_RELEASE_DL_DIR ?= "${DL_DIR}"
ARCHIVE_RELEASE_DL_BY_LAYER_PATH = '${TMPDIR}/downloads-by-layer.txt'

def mel_get_remotes(subdir, d):
    """Any non-public github repo or url including a mentor domain
    are considered private, so no remote is included.
    """
    url = bb.process.run(['git', 'config', 'remote.origin.url'], cwd=subdir)[0].rstrip()
    if not url:
        return None

    remotes = {}
    test_url = url.replace('.git', '')
    public_repos = d.getVar('PUBLIC_REPOS').split()
    if 'MentorEmbedded' in test_url:
        if not any(test_url.endswith('/' + i) for i in public_repos):
            # Private github repo
            return None
        else:
            # For the public layers, we want the user to be able to fetch
            # anonymously, not just with ssh
            url = url.replace('ssh://git@', 'https://')

            forked_repos = d.getVar('FORKED_REPOS').split()
            for f in forked_repos:
                if test_url.endswith('/' + f):
                    upstream = d.getVar('UPSTREAM_URL_%s' % f)
                    if upstream:
                        remotes['upstream'] = upstream
                        break
    elif 'mentor.com' in test_url or 'mentorg.com' in test_url:
        # Internal repo
        return None

    remotes['origin'] = url
    return remotes

GET_REMOTES_HOOK_mel ?= "mel_get_remotes"

def get_release_info(layerdir, layername, topdir, oedir, indiv_only=None, indiv_only_toplevel=None, indiv_manifests=None):
    import fnmatch

    if indiv_only is None:
        indiv_only = set()
    if indiv_only_toplevel is None:
        indiv_only_toplevel = set()
    if indiv_manifests is None:
        indiv_manifests = []

    parent = os.path.dirname(layerdir)
    relpath = None
    if (layerdir not in indiv_only and
            not os.path.exists(os.path.join(layerdir, '.git')) and
            parent not in (oedir, topdir) and
            os.path.exists(os.path.join(parent, '.git'))):
        ls = bb.process.run(['git', 'ls-tree', '-d', 'HEAD', layerdir], cwd=parent)
        if ls:
            return parent, os.path.basename(parent), False

    if layername and any(fnmatch.fnmatchcase(layername, pat) for pat in indiv_manifests):
        indiv_layer = True
    else:
        indiv_layer = False

    if (layerdir not in indiv_only_toplevel and
            not layerdir.startswith(topdir + os.sep) and
            layerdir.startswith(oedir + os.sep)):
        return layerdir, os.path.relpath(layerdir, oedir), indiv_layer
    else:
        return layerdir, os.path.basename(layerdir), indiv_layer

python do_archive_mel_layers () {
    """Archive the layers used to build, as git pack files, with a manifest."""
    import collections
    import configparser

    if 'layerdirs' not in d.getVar('INHERIT').split():
        save_layerdirs(d)

    directories = d.getVar('BBLAYERS').split()
    bitbake_path = bb.utils.which(d.getVar('PATH'), 'bitbake')
    bitbake_bindir = os.path.dirname(bitbake_path)
    directories.append(os.path.dirname(bitbake_bindir))

    corebase = os.path.realpath(d.getVar('COREBASE'))
    oedir = os.path.dirname(corebase)
    topdir = os.path.realpath(d.getVar('TOPDIR'))
    indiv_only_toplevel = d.getVar('SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL').split()
    indiv_only = d.getVar('SUBLAYERS_INDIVIDUAL_ONLY').split() + indiv_only_toplevel
    indiv_manifests = d.getVar('INDIVIDUAL_MANIFEST_LAYERS').split()
    excluded_layers = d.getVar('RELEASE_EXCLUDED_LAYERNAMES').split()
    get_remotes_hook = d.getVar('GET_REMOTES_HOOK')
    if get_remotes_hook:
        get_remotes = bb.utils.get_context().get(get_remotes_hook)
        if not get_remotes:
            bb.fatal('Hook function specified in GET_REMOTES_HOOK (`%s`) does not exist' % get_remotes_hook)
    else:
        get_remotes = None

    layernames = {}
    for layername in d.getVar('BBFILE_COLLECTIONS').split():
        layerdir = d.getVar('LAYERDIR_%s' % layername)
        if layerdir:
            layernames[layerdir] = layername

    to_archive, indiv_manifest_dirs = set(), set()
    path = d.getVar('PATH') + ':' + ':'.join(os.path.join(l, '..', 'scripts') for l in directories)
    for subdir in directories:
        subdir = os.path.realpath(subdir)
        layername = layernames.get(subdir)
        if layername in excluded_layers:
            continue
        archive_path, dest_path, is_indiv = get_release_info(subdir, layername, topdir, oedir, indiv_only=indiv_only, indiv_only_toplevel=indiv_only_toplevel, indiv_manifests=indiv_manifests)
        to_archive.add((archive_path, dest_path))
        if is_indiv:
            indiv_manifest_dirs.add(subdir)

    outdir = d.expand('${S}/do_archive_mel_layers')
    mandir = os.path.join(outdir, 'manifests')
    bb.utils.mkdirhier(mandir)
    bb.utils.mkdirhier(os.path.join(mandir, 'extra'))
    objdir = os.path.join(outdir, 'objects', 'pack')
    bb.utils.mkdirhier(objdir)
    manifestfn = d.expand('%s/${MANIFEST_NAME}.manifest' % mandir)
    manifests = [manifestfn]
    message = '%s release' % d.getVar('DISTRO')

    manifestdata = collections.defaultdict(list)
    for subdir, path in sorted(to_archive):
        pack_base, head = git_archive(subdir, objdir, message)
        if get_remotes:
            remotes = get_remotes(subdir, d) or {}
        else:
            remotes = {}

        if not remotes:
            bb.note('Skipping remotes for %s' % path)

        if subdir in indiv_manifest_dirs:
            name = path.replace('/', '_')
            bb.utils.mkdirhier(os.path.join(mandir, 'extra', name))
            fn = d.expand('%s/extra/%s/${EXTRA_MANIFEST_NAME}-%s.manifest' % (mandir, name, name))
        else:
            fn = manifestfn
        manifestdata[fn].append('\t'.join([path, head] + ['%s=%s' % (k,v) for k,v in remotes.items()]) + '\n')
        bb.process.run(['tar', '-cf', '%s.tar' % pack_base, 'objects/pack/%s.pack' % pack_base, 'objects/pack/%s.idx' % pack_base], cwd=outdir)

    infofn = d.expand('%s/${MANIFEST_NAME}.info' % mandir)
    with open(infofn, 'w') as infofile:
        c = configparser.ConfigParser()
        c['DEFAULT'] = {'bspfiles_path': d.getVar('BSPFILES_INSTALL_PATH')}
        c.write(infofile)

    for fn, lines in manifestdata.items():
        with open(fn, 'w') as manifest:
            manifest.writelines(lines)
            files = [os.path.relpath(fn, outdir)]
            if fn == manifestfn:
                files.append(os.path.relpath(infofn, outdir))
        bb.process.run(['tar', '-cf', os.path.basename(fn) + '.tar'] + files, cwd=outdir)

    scripts = d.getVar('MEL_SCRIPTS_FILES').split()
    bb.process.run(['rm', '-r', 'objects'], cwd=outdir)
    bb.process.run(['tar', '--transform=s,^,scripts/,', '--transform=s,^scripts/setup-mel,setup-mel,', '-cvf', d.expand('%s/${SCRIPTS_ARTIFACT_NAME}.tar' % outdir)] + scripts, cwd=d.getVar('WORKDIR'))
}
do_archive_mel_layers[dirs] = "${S}/do_archive_mel_layers ${S}"
do_archive_mel_layers[vardeps] += "${GET_REMOTES_HOOK}"
# We make use of the distro version, so want to avoid changing checksum issues
# for snapshot builds.
do_archive_mel_layers[vardepsexclude] += "DATE TIME"
addtask archive_mel_layers after do_patch

def git_archive(subdir, outdir, message=None):
    """Create an archive for the specified subdir, holding a single git object

    1. Clone or create the repo to a temporary location
    2. Make the repo shallow
    3. Repack the repo into a single git pack
    4. Copy the pack files to outdir
    """
    import glob
    import tempfile
    if message is None:
        message = 'Release of %s' % os.path.basename(subdir)

    parent = None
    if os.path.exists(os.path.join(subdir, '.git')):
        parent = subdir
    else:
        try:
            git_topdir = bb.process.run(['git', 'rev-parse', '--show-toplevel'], cwd=subdir)[0].rstrip()
        except bb.process.CmdError:
            pass
        else:
            if git_topdir != subdir:
                subdir_relpath = os.path.relpath(subdir, git_topdir)
                try:
                    ls = bb.process.run(['git', 'ls-tree', '-d', 'HEAD', subdir_relpath], cwd=subdir)
                except bb.process.CmdError as exc:
                    pass
                else:
                    if ls:
                        parent = git_topdir

    if parent:
        parent_git = os.path.join(parent, bb.process.run(['git', 'rev-parse', '--git-dir'], cwd=subdir)[0].rstrip())
        # Handle git worktrees
        _commondir = os.path.join(parent_git, 'commondir')
        if os.path.exists(_commondir):
            with open(_commondir, 'r') as f:
                parent_git = os.path.join(parent_git, f.read().rstrip())

    with tempfile.TemporaryDirectory() as tmpdir:
        gitcmd = ['git', '--git-dir', tmpdir, '--work-tree', subdir]
        commitcmd = ['commit-tree', '-m', message]
        bb.process.run(gitcmd + ['init'])
        if parent:
            with open(os.path.join(tmpdir, 'objects', 'info', 'alternates'), 'w') as f:
                f.write(os.path.join(parent_git, 'objects') + '\n')
            parent_head = bb.process.run(['git', 'rev-parse', 'HEAD'], cwd=subdir)[0].rstrip()
            bb.process.run(gitcmd + ['read-tree', parent_head])
            commitcmd.extend(['-p', parent_head])

            try:
                cdate, adate = bb.process.run(['git', 'log', '--pretty=%ct\t%at', '-1', '--', os.path.relpath(subdir, parent)], cwd=parent)[0].rstrip().split('\t')
            except bb.process.CmdError:
                bb.warn('Error determining commit dates for %s' % subdir)
                cdate, adate = None, None

        bb.process.run(gitcmd + ['add', '-A', '.'], cwd=subdir)
        tree = bb.process.run(gitcmd + ['write-tree'])[0].rstrip()
        commitcmd.append(tree)

        if not parent or not cdate:
            st = os.stat(os.path.join(subdir, 'conf', 'layer.conf'))
            cdate = adate = st.st_mtime

        env = {
            'GIT_AUTHOR_NAME': 'Build User',
            'GIT_AUTHOR_EMAIL': 'build_user@build_host',
            'GIT_AUTHOR_DATE': str(adate),
            'GIT_COMMITTER_NAME': 'Build User',
            'GIT_COMMITTER_EMAIL': 'build_user@build_host',
            'GIT_COMMITTER_DATE': str(cdate),
        }

        head = bb.process.run(gitcmd + commitcmd, env=env)[0].rstrip()
        with open(os.path.join(tmpdir, 'shallow'), 'w') as f:
            f.write(head + '\n')

        # We need a ref to ensure repack includes the new commit, as it
        # does not include dangling objects in the pack.
        bb.process.run(['git', 'update-ref', 'refs/packing', head], cwd=tmpdir)
        bb.process.run(['git', 'prune', '--expire=now'], cwd=tmpdir)
        bb.process.run(['git', 'repack', '-a', '-d'], cwd=tmpdir)
        bb.process.run(['git', 'prune-packed'], cwd=tmpdir)

        packdir = os.path.join(tmpdir, 'objects', 'pack')
        packfiles = glob.glob(os.path.join(packdir, 'pack-*'))
        base, ext = os.path.splitext(os.path.basename(packfiles[0]))
        bb.process.run(['cp', '-f'] + packfiles + [outdir])
        return base, head

def checksummed_downloads(dl_by_layer_fn, dl_by_layer_dl_dir, dl_dir):
    with open(dl_by_layer_fn, 'r') as f:
        lines = f.readlines()

    for layer_name, dl_path in (l.rstrip('\n').split('\t', 1) for l in lines):
        rel_path = os.path.relpath(dl_path, dl_by_layer_dl_dir)
        if rel_path.startswith('..'):
            bb.fatal('Download %s (in %s) is not relative to DL_DIR' % (dl_path, dl_by_layer_fn))

        dl_path = os.path.join(dl_dir, rel_path)
        if not os.path.exists(dl_path):
            # download is missing, probably excluded for license reasons
            bb.warn('Download %s does not exist, excluding' % dl_path)
            continue

        checksum = chksum_dl(dl_path)
        yield layer_name, dl_path, rel_path, checksum

def uninative_downloads(workdir, dldir):
    for path in oe.path.find(os.path.join(workdir, 'uninative')):
        relpath = os.path.relpath(path, workdir)
        dlpath = os.path.join(dldir, relpath)
        checksum = chksum_dl(path, dlpath)
        yield None, path, relpath, checksum

def chksum_dl(path, dlpath=None):
    import pickle

    if dlpath is None:
        dlpath = path

    donefile = dlpath + '.done'
    checksum = None
    if os.path.exists(donefile):
        with open(donefile, 'rb') as cachefile:
            try:
                checksums = pickle.load(cachefile)
            except EOFError:
                pass
            else:
                checksum = checksums['sha256']

    if not checksum:
        checksum = bb.utils.sha256_file(path)

    return checksum

python do_archive_mel_downloads () {
    import collections
    import pickle
    import oe.path

    dl_dir = d.getVar('DL_DIR')
    archive_dl_dir = d.getVar('ARCHIVE_RELEASE_DL_DIR') or dl_dir
    dl_by_layer_fn = d.getVar('ARCHIVE_RELEASE_DL_BY_LAYER_PATH')
    if not os.path.exists(dl_by_layer_fn):
        bb.fatal('%s does not exist, but mel_downloads requires it. Please run `bitbake-layers dump-downloads` with appropriate arguments.' % dl_by_layer_fn)

    downloads = list(checksummed_downloads(dl_by_layer_fn, dl_dir, archive_dl_dir))
    downloads.extend(sorted(uninative_downloads(d.getVar('WORKDIR'), d.getVar('DL_DIR'))))
    outdir = d.expand('${S}/do_archive_mel_downloads')
    mandir = os.path.join(outdir, 'manifests')
    dldir = os.path.join(outdir, 'downloads')
    bb.utils.mkdirhier(mandir)
    bb.utils.mkdirhier(os.path.join(mandir, 'extra'))
    bb.utils.mkdirhier(dldir)

    layer_manifests = {}
    corebase = os.path.realpath(d.getVar('COREBASE'))
    oedir = os.path.dirname(corebase)
    topdir = os.path.realpath(d.getVar('TOPDIR'))
    indiv_only_toplevel = d.getVar('SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL').split()
    indiv_only = d.getVar('SUBLAYERS_INDIVIDUAL_ONLY').split() + indiv_only_toplevel
    indiv_manifests = d.getVar('INDIVIDUAL_MANIFEST_LAYERS').split()

    layers = set(i[0] for i in downloads)
    for layername in layers:
        if not layername:
            continue

        layerdir = d.getVar('LAYERDIR_%s' % layername)
        archive_path, dest_path, is_indiv = get_release_info(layerdir, layername, topdir, oedir, indiv_only=indiv_only, indiv_only_toplevel=indiv_only_toplevel, indiv_manifests=indiv_manifests)
        if is_indiv:
            extra_name = dest_path.replace('/', '_')
            bb.utils.mkdirhier(os.path.join(mandir, 'extra', extra_name))
            manifestfn = d.expand('%s/extra/%s/${EXTRA_MANIFEST_NAME}-%s.downloads' % (mandir, extra_name, extra_name))
            layer_manifests[layername] = manifestfn

    main_manifest = d.expand('%s/${MANIFEST_NAME}.downloads' % mandir)
    manifests = collections.defaultdict(list)
    for layername, path, dest_path, checksum in downloads:
        manifestfn = layer_manifests.get(layername) or main_manifest
        manifests[manifestfn].append((layername, path, dest_path, checksum))

    for manifest, manifest_downloads in manifests.items():
        with open(manifest, 'w') as f:
            for _, _, download_path, checksum in manifest_downloads:
                f.write('%s\t%s\n' % (download_path, checksum))

        bb.process.run(['tar', '-cf', os.path.basename(manifest) + '.tar', os.path.relpath(manifest, outdir)], cwd=outdir)

        for name, path, dest_path, checksum in manifest_downloads:
            dest = os.path.join(dldir, checksum)
            oe.path.symlink(path, dest, force=True)
            bb.process.run(['tar', '-chf', '%s/download-%s.tar' % (dldir, checksum), os.path.relpath(dest, outdir)], cwd=outdir)
            os.unlink(dest)
}
do_archive_mel_downloads[depends] += "${@'${RELEASE_IMAGE}:${FETCHALL_TASK}' if '${RELEASE_IMAGE}' else ''}"

archive_uninative_downloads () {
    # Ensure that uninative downloads are in ARCHIVE_RELEASE_DL_DIR, since
    # they're listed in the manifest
    find uninative -type f | while read -r fn; do
        mkdir -p "${ARCHIVE_RELEASE_DL_DIR}/$(dirname "$fn")"
        ln -sf "${DL_DIR}/$fn" "${ARCHIVE_RELEASE_DL_DIR}/$fn"
    done
}
archive_uninative_downloads[dirs] = "${WORKDIR}"
do_archive_mel_downloads[prefuncs] += "archive_uninative_downloads"
