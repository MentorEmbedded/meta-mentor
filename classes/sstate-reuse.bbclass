def recipe_type(d):
    try:
        oe
    except NameError:
        oe_import(d)

    for recipe_type in oe.data.typed_value('AVAILABLE_RECIPE_TYPES', d):
        if oe.utils.inherits(d, recipe_type):
            return recipe_type
    return 'target'

RECIPE_TYPE = "${@recipe_type(d)}"
RECIPE_TYPE[doc] = 'The "type" of the current recipe (e.g. target, native, cross)'

AVAILABLE_RECIPE_TYPES = 'target native nativesdk cross crosssdk cross-canadian'
AVAILABLE_RECIPE_TYPES[type] = 'list'
AVAILABLE_RECIPE_TYPES[doc] = 'Space separated list of available recipe types'


LSB_DISTRO_ADJUST ?= ""
LSB_DISTRO_ID = "${@lsb_distro_identifier(d)}"

def lsb_distro_identifier(d):
    import oe_lsb

    adjust = d.getVar('LSB_DISTRO_ADJUST', True)
    adjust_func = None
    if adjust:
        try:
            adjust_func = globals()[adjust]
        except KeyError:
            pass
    return oe_lsb.distro_identifier(adjust_func)


# Structure SSTATE_DIR such that non-target sstates are placed in a directory
# specific to the host we're running on, and allow fallback to sstates from
# compatible hosts.
SSTATE_DIR .= '/${LSB_DISTRO_ID}'
SSTATE_MIRRORS .= 'file://.* file://${SSTATE_DIR}/../\n'
SSTATE_MIRROR_HOSTS ?= ""
# Ensure we check for sstates specific to this host before falling back to
# other, compatible ones
SSTATE_MIRROR_HOSTS =. "${LSB_DISTRO_ID} "

# Move target sstates up out of the host-bound area
sstate_create_package_append () {
	if [ "${RECIPE_TYPE}" = "target" ]; then
		fn=$(basename ${SSTATE_PKG})
		if [ ! -e ${SSTATE_DIR}/../$fn ]; then
			mv ${SSTATE_PKG} ${SSTATE_DIR}/../
			ln -s ../$fn ${SSTATE_PKG}
		fi
	fi
}

# Yield unique elements of an iterable
def iter_uniq(iterable):
    seen = set()
    for i in iterable:
        if i not in seen:
            seen.add(i)
            yield i

# Adjust mirrors so host-bound sstate packages can be fetched from them
python sstate_mirror_add_hosts() {
    if not isinstance(e, bb.event.ConfigParsed):
        return
    d = e.data

    hosts = d.getVar('SSTATE_MIRROR_HOSTS', False).split()
    mirrors = d.getVar('SSTATE_MIRRORS', False).replace("\\n", "\n").split("\n")
    new_mirrors = []
    for mirror_line in mirrors:
        if not mirror_line:
            continue

        pattern, replace = mirror_line.split()
        host_lines = ['{0} {1}/'.format(pattern, os.path.join(replace, host))
                                        for host in hosts]
        new_mirrors.extend(host_lines)
        new_mirrors.append(mirror_line)
    new_mirrors.remove('file://.* file://${SSTATE_DIR}/../${LSB_DISTRO_ID}/')
    d.setVar('SSTATE_MIRRORS', "\\n".join(iter_uniq(new_mirrors)))
}
addhandler sstate_mirror_add_hosts
