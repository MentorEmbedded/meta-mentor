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

# Adjust mirrors so host-bound sstate packages can be fetched from them
python sstate_reuse_setup() {
    if not isinstance(e, bb.event.ConfigParsed):
        return
    d = e.data

    mirrors = d.getVar('SSTATE_MIRRORS', False).replace("\\n", "\n").split("\n")
    distros = d.getVar('SSTATE_MIRROR_DISTROS', False).split()
    sites = d.getVar('SSTATE_MIRROR_SITES', False).split()
    for site in sites:
        # Support structured mirror
        mirrors.append('file://.* %s/PATH' % site)

        # Fall back in structure to our compatible distros
        for distro in distros:
            mirrors.append('file://${NATIVELSBSTRING} %s/%s' % (site, distro))

        # Support flattened mirror
        mirrors.append('file://.* %s' % site)

    # Fall back in structure to our compatible distros
    for distro in distros:
        mirrors.append('file://${NATIVELSBSTRING} file://${SSTATE_DIR}/%s' % distro)

    d.setVar('SSTATE_MIRRORS', "\\n".join(iter_uniq(filter(None, mirrors))))
}
addhandler sstate_reuse_setup
