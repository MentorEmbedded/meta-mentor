SSTATE_MIRRORS ?= ""
SSTATE_MIRROR_SITES ?= ""
SSTATE_MIRROR_DISTROS ?= ""

# Yield unique elements of an iterable
def iter_uniq(iterable):
    seen = set()
    for i in iterable:
        if i not in seen:
            seen.add(i)
            yield i

# Support use of native sstates from compatible distros
python sstate_reuse_setup() {
    d = e.data

    mirrors = d.getVar('SSTATE_MIRRORS', False).replace("\\n", "\n").split("\n")
    distros = d.getVar('SSTATE_MIRROR_DISTROS', False).split()

    # Fall back in SSTATE_DIR structure to our compatible distros
    for distro in distros:
        mirrors.append('file://${NATIVELSBSTRING} file://${SSTATE_DIR}/%s;downloadfilename=PATH' % distro)

    sites = d.getVar('SSTATE_MIRROR_SITES', False).split()
    for site in sites:
        # Support structured mirror
        mirrors.append('file://.* %s/PATH;downloadfilename=PATH' % site)

        # Fall back in mirror structure to our compatible distros
        for distro in distros:
            mirrors.append('file://${NATIVELSBSTRING} %s/%s;downloadfilename=PATH' % (site, distro))

        # Support flattened mirror
        mirrors.append('file://.* %s;downloadfilename=PATH' % site)

    d.setVar('SSTATE_MIRRORS', "\\n".join(iter_uniq(filter(None, mirrors))))
}
sstate_reuse_setup[eventmask] = "bb.event.ConfigParsed"
addhandler sstate_reuse_setup
