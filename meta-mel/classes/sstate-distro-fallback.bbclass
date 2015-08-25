# This class takes any local distro fallback mirror line of the form
# 'file://<distro> file://<other distro>' and applies this fallback to the
# other mirrors in SSTATE_MIRRORS.

SSTATE_MIRRORS_append = " ${SSTATE_DISTRO_FALLBACKS}"
SSTATE_DISTRO_FALLBACKS ?= "\
    file://Ubuntu-15.04 file://Ubuntu-14.10 \n \
    file://Ubuntu-14.10 file://Ubuntu-14.04 \n \
    file://Ubuntu-14.04 file://Ubuntu-13.10 \n \
    file://Ubuntu-13.10 file://Ubuntu-13.04 \n \
    file://Ubuntu-13.04 file://Ubuntu-12.10 \n \
    file://Ubuntu-12.10 file://Ubuntu-12.04 \n \
    file://openSUSE-13.2 file://openSUSE-13.1 \n \
    file://openSUSE-13.1 file://openSUSE-12.3 \n \
    file://Fedora-22 file://Fedora-21 \n \
    file://Fedora-21 file://Fedora-20 \n \
    file://Fedora-20 file://Fedora-19 \n \
"

python add_sstate_distro_fallback_mirrors() {
    import collections
    url = collections.namedtuple('url', 'scheme host path user password params')

    sstate_mirror_urls = []
    sstate_distro_fallbacks = []
    mirrors = bb.fetch.mirror_from_string(d.getVar('SSTATE_MIRRORS', True))
    for m in mirrors:
        if len(m) != 2:
            continue

        find = url._make(bb.fetch.decodeurl(m[0]))
        replace = url._make(bb.fetch.decodeurl(m[1]))
        if find.scheme != 'file':
            continue

        if find.path == '.*' and replace.path.endswith('/PATH'):
            sstate_mirror_urls.append(bb.fetch.encodeurl(replace._replace(path=replace.path[:-5])))
        elif (replace.scheme == 'file' and
              '/' not in find.path and '/' not in replace.path):
            sstate_distro_fallbacks.append((find.path, replace.path))

    fallback_mirrors = []
    for urlstring in sstate_mirror_urls:
        mirror_url = url._make(bb.fetch.decodeurl(urlstring))
        for fromdistro, todistro in sstate_distro_fallbacks:
            newurl = bb.fetch.encodeurl(mirror_url._replace(path=mirror_url.path + '/' + todistro))
            fallback_mirrors.append(r'file://{0} {1} \n'.format(fromdistro, newurl))

    d.appendVar('SSTATE_MIRRORS', ' ' + ''.join(fallback_mirrors))
}
add_sstate_distro_fallback_mirrors[eventmask] = "bb.event.ConfigParsed"
addhandler add_sstate_distro_fallback_mirrors
