FILESEXTRAPATHS_append = ":${@':'.join('%s/../scripts/release' % l for l in '${BBPATH}'.split(':'))}"
SRC_URI += "\
    file://mel-checkout \
    file://setup-environment \
"

inherit layerdirs

ARCHIVE_RELEASE_VERSION ?= "${DISTRO_VERSION}"
MANIFEST_NAME ?= "${DISTRO}-${ARCHIVE_RELEASE_VERSION}-${MACHINE}"
EXTRA_MANIFEST_NAME ?= "${DISTRO}-${ARCHIVE_RELEASE_VERSION}"
BSPFILES_INSTALL_PATH = "${MACHINE}/${ARCHIVE_RELEASE_VERSION}"
GET_REMOTES_HOOK ?= ""

# Layers which get their own extra manifests, rather than being included in
# the main one. How they're combined or shipped from there is up to our
# release scripts.
INDIVIDUAL_MANIFEST_LAYERS ?= ""
FORKED_REPOS ?= ""
PUBLIC_REPOS ?= "${FORKED_REPOS}"

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

python do_archive_mel_layers () {
    """Archive the layers used to build, as git pack files, with a manifest."""
    import collections
    import configparser
    import fnmatch

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
        parent = os.path.dirname(subdir)
        relpath = None
        if (subdir not in indiv_only and
                not os.path.exists(os.path.join(subdir, '.git')) and
                parent not in (oedir, topdir) and
                os.path.exists(os.path.join(parent, '.git'))):
            ls = bb.process.run(['git', 'ls-tree', '-d', 'HEAD', subdir], cwd=parent)
            if ls:
                to_archive.add((parent, os.path.basename(parent)))
                continue

        if (subdir not in indiv_only_toplevel and
                not subdir.startswith(topdir + os.sep) and
                subdir.startswith(oedir + os.sep)):
            to_archive.add((subdir, os.path.relpath(subdir, oedir)))
        else:
            to_archive.add((subdir, os.path.basename(subdir)))

        layername = layernames.get(subdir)
        if layername and any(fnmatch.fnmatchcase(layername, pat) for pat in indiv_manifests):
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

    envpath = './setup-mel'
    checkoutpath = './scripts/mel-checkout'
    bb.process.run(['rm', '-r', 'objects'], cwd=outdir)
    bb.process.run(['tar', '--transform=s,mel-checkout,%s,' % checkoutpath, '--transform=s,setup-environment,%s,' % envpath, '-cf', d.expand('%s/${DISTRO}-scripts.tar' % outdir), 'mel-checkout', 'setup-environment'], cwd=d.getVar('WORKDIR'))
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

    if os.path.exists(os.path.join(subdir, '.git')):
        parent = subdir
        # Handle .git as a file i.e. submodules
        parent_git = os.path.join(parent, bb.process.run(['git', 'rev-parse', '--git-dir'], cwd=subdir)[0].rstrip())
        # Handle git worktrees
        _commondir = os.path.join(parent_git, 'commondir')
        if os.path.exists(_commondir):
            with open(_commondir, 'r') as f:
                parent_git = os.path.join(parent_git, f.read().rstrip())
    else:
        parent = None

    with tempfile.TemporaryDirectory() as tmpdir:
        gitcmd = ['git', '--git-dir', tmpdir, '--work-tree', subdir]
        bb.process.run(gitcmd + ['init'])
        if parent:
            with open(os.path.join(tmpdir, 'objects', 'info', 'alternates'), 'w') as f:
                f.write(os.path.join(parent_git, 'objects') + '\n')
            parent_head = bb.process.run(['git', 'rev-parse', 'HEAD'], cwd=subdir)[0].rstrip()
            bb.process.run(gitcmd + ['read-tree', parent_head])

        bb.process.run(gitcmd + ['add', '-A', '.'], cwd=subdir)
        tree = bb.process.run(gitcmd + ['write-tree'])[0].rstrip()

        env = {
            'GIT_AUTHOR_NAME': 'Build User',
            'GIT_AUTHOR_EMAIL': 'build_user@build_host',
            'GIT_COMMITTER_NAME': 'Build User',
            'GIT_COMMITTER_EMAIL': 'build_user@build_host',
        }
        if parent:
            # Walk the commits until we get a date, as merges don't seem to
            # report a commit date.
            cdate, distance = None, 0
            while not cdate:
                try:
                    cdate = bb.process.run(['git', 'diff-tree', '--pretty=format:%ct', '-s', 'HEAD~%d' % distance], cwd=subdir)[0]
                except bb.process.CmdError:
                    break
                distance += 1

            penv = dict(env)
            if cdate:
                penv.update(GIT_AUTHOR_DATE=cdate, GIT_COMMITTER_DATE=cdate)

            head = bb.process.run(gitcmd + ['commit-tree', '-m', message, '-p', parent_head, tree], env=penv)[0].rstrip()
            with open(os.path.join(tmpdir, 'shallow'), 'w') as f:
                f.write(head + '\n')
        else:
            head = bb.process.run(gitcmd + ['commit-tree', '-m', message, tree], env=env)[0].rstrip()

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

