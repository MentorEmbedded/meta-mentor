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


DEFCONFIG ?= "${WORKDIR}/defconfig"
merge_fragment_pipeline = "cat"

do_prepare_config () {
    if [ ! -e "${DEFCONFIG}" ]; then
        bbfatal "Configuration file '${DEFCONFIG}' does not exist"
    fi

    install_config
    merge_fragments ${B}/.config

    # Sanity check in case do_configure wants to overwrite this
    chmod -w ${B}/.config
}

do_prepare_config[dirs] = "${S}"
do_prepare_config[depends] += "kern-tools-native:do_populate_sysroot"

addtask prepare_config before do_configure after do_patch

install_config () {
    cp -f ${DEFCONFIG} ${B}/.config
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
    sources = src_patches(d, True)
    return [s for s in sources if s.endswith('.cfg')]
