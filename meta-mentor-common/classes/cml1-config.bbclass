# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# Consistent handling of the defconfig -> .config, with merge of config
# fragments using the same mechanism as busybox and linux-yocto.
#
# The functionality is split into a number of small functions to easier
# facilitate recipe alteration of the process, or filtering of the fragments
# to be merged. To filter the fragments in use, append to the pipeline (after
# the inherit of this class):
#
#     merge_fragment_pipeline .= "| my_filter"
#
# Note: due to bitbake's use of set -e, the filter must return success (0).

# For merge_config.sh
DEPENDS += "kern-tools-native"

DEFCONFIG ?= "${WORKDIR}/defconfig"
merge_fragment_pipeline = "cat"

do_configure:prepend () {
    DEFCONFIG="${DEFCONFIG}"
    if [ "${DEFCONFIG#/}" = "${DEFCONFIG}" ]; then
        DEFCONFIG="${S}/${DEFCONFIG}"
    fi

    if [ ! -e "$DEFCONFIG" ]; then
        bbfatal "Configuration file '${DEFCONFIG}' does not exist"
    fi

    install_config
    merge_fragments ${B}/.config
}

install_config () {
    cp -f $DEFCONFIG ${B}/.config
}

merge_fragments () {
    list_fragments | ${merge_fragment_pipeline} >"${B}/fragments"
    merge_config.sh -m "$1" $(cat "${B}/fragments")
}

list_fragments () {
    cat <<END
    ${@"\n".join(src_config_fragments(d))}
END
}

def src_config_fragments(d):
    workdir = d.getVar('WORKDIR')
    fetch = bb.fetch2.Fetch([], d)
    for url in fetch.urls:
        urldata = fetch.ud[url]
        urldata.setup_localpath(d)

        unpacked_path = unpack_path(urldata, workdir, lambda f: f.endswith('cfg'))
        if unpacked_path:
            yield unpacked_path

# This is directly from bitbake's fetch2 unpack() method
def unpack_path(urldata, rootdir, filter_path=None):
    localpath = urldata.localpath

    # Localpath can't deal with 'dir/*' entries, so it converts them to '.',
    # but it must be corrected back for local files copying
    if urldata.basename == '*' and localpath.endswith('/.'):
        localpath = '%s/%s' % (file.rstrip('/.'), urldata.path)

    base, ext = os.path.splitext(localpath)
    if ext in ['.gz', '.bz2', '.Z', '.xz', '.lz']:
        efile = os.path.join(rootdir, os.path.basename(base))
    else:
        efile = localpath

    if not filter_path or not filter_path(efile):
        return

    if 'subdir' in urldata.parm:
        subdir = urldata.parm.get('subdir')
        if os.path.isabs(subdir):
            if not os.path.realpath(subdir).startswith(os.path.realpath(rootdir)):
                bb.fatal("subdir argument isn't a subdirectory of unpack root %s" % rootdir, urldata.url)
            unpackdir = subdir
        else:
            unpackdir = os.path.join(rootdir, subdir)
    else:
        unpackdir = rootdir

    destdir = '.'
    # For file:// entries all intermediate dirs in path must be created at destination
    if urldata.type == "file":
        # Trailing '/' does a copying to wrong place
        urlpath = urldata.path.rstrip('/')
        # Want files places relative to cwd so no leading '/'
        urlpath = urlpath.lstrip('/')
        if urlpath.find("/") != -1:
            destdir = urlpath.rsplit("/", 1)[0] + '/'

    return os.path.join(unpackdir, destdir, os.path.basename(efile))
