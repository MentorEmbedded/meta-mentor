DESCRIPTION = "Archive the artifacts for a ${DISTRO_NAME} release"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
INHIBIT_DEFAULT_DEPS = "1"
PROVIDES += "mel-release"
PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = ""
EXCLUDE_FROM_WORLD = "1"

SRC_URI += "${@' '.join(uninative_urls(d)) if 'downloads' in '${RELEASE_ARTIFACTS}'.split() else ''}"
SRC_URI_append_qemuall = " file://runqemu.in"

# We're using image fstypes data, inherit the class in case variables from it
# are needed for IMAGE_FSTYPES
inherit image_types

UNINATIVE_BUILD_ARCHES ?= "x86_64 i686"
MELDIR ?= "${COREBASE}/.."
TEMPLATECONF ?= "${FILE_DIRNAME}/../../../conf"

PROBECONFIGS ?= "${@bb.utils.which('${BBPATH}', 'conf/probe-configs/${MACHINE}')}" 

BSPFILES_INSTALL_PATH ?= "${MACHINE}"
BINARY_INSTALL_PATH ?= "${BSPFILES_INSTALL_PATH}/binary"
CONF_INSTALL_PATH ?= "${BSPFILES_INSTALL_PATH}/conf"
PROBECONFIGS_INSTALL_PATH ?= "${BSPFILES_INSTALL_PATH}/probe-configs"

# Add a default in case the user doesn't inherit copyleft_compliance
ARCHIVE_RELEASE_DL_DIR ?= "${DL_DIR}"
ARCHIVE_RELEASE_DL_TOPDIR ?= "${DL_DIR}"

# Default to shipping update-* as individual artifacts
def configured_update_layers(d):
    """Return the configured layers whose basenames are update-*"""
    update_layers = set()
    for layer in d.getVar('BBLAYERS', True).split():
        basename = os.path.basename(layer)
        if basename.startswith('update-'):
            update_layers.add(layer)
    return ' '.join(sorted(update_layers))

def configured_mx6_layers(d):
    """Return the mx6 layers to be archived as individual tarballs"""
    mx6_layers = set()
    for layer in d.getVar('BBLAYERS', True).split():
        basename = os.path.basename(layer)
        if 'mx6' in basename:
            mx6_layers.add(layer)
    return ' '.join(sorted(mx6_layers))

# Sub-layers to archive individually, rather than grabbing the entire
# repository they're in
def layers_by_name(d, *layers):
    for l in layers:
        v = d.getVar('LAYERDIR_%s' % l, True)
        if v:
            yield v

SUBLAYERS_INDIVIDUAL_ONLY ?= "${@configured_mx6_layers(d)} ${@' '.join(layers_by_name(d, 'mentor-bsp', 'mentor-bsp-${MACHINE}'))}"
SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL ?= "${@configured_update_layers(d)}"

DEPLOY_DIR_RELEASE ?= "${DEPLOY_DIR}/release-artifacts"
RELEASE_ARTIFACTS ?= "layers bitbake templates images downloads sstate probeconfigs"
RELEASE_ARTIFACTS[doc] = "List of artifacts to include (available: layers, bitbake, templates, images, downloads, sstate, probeconfigs"
RELEASE_IMAGE ?= "core-image-base"
RELEASE_IMAGE[doc] = "The image to build and archive in this release"
RELEASE_USE_TAGS ?= "false"
RELEASE_USE_TAGS[doc] = "Use git tags rather than just # of commits for layer archive versioning"
RELEASE_USE_TAGS[type] = "boolean"
RELEASE_EXCLUDED_SOURCES ?= ""
RELEASE_EXCLUDED_SOURCES[doc] = "Patterns of files in ARCHIVE_RELEASE_DL_DIR to exclude"
BINARY_ARTIFACTS_COMPRESSION ?= ""
BINARY_ARTIFACTS_COMPRESSION[doc] = "Compression type for images, downloads and sstate artifacts.\
 Available: '.bz2' and '.gz'. No compression if empty"

LAYERS_OWN_DOWNLOADS ?= "${@' '.join(l for l in '${BBFILE_COLLECTIONS}'.split() if l.startswith('update-'))}"
LAYERS_OWN_DOWNLOADS[doc] = "Names of layers whose downloads should be shipped inside the layer itself, self contained."

# If we have an isolated set of shared state archives, use that, so as to
# avoid archiving sstates which were unused.
ARCHIVE_SSTATE_DIR = "${@ISOLATED_SSTATE_DIR \
                         if oe.utils.inherits(d, 'isolated-sstate-dir') \
                            else SSTATE_DIR}"

# Kernel images and filesystems are handled separately, as they produce
# timestamped filenames, and we only want the current ones (symlinked ones).
DEPLOY_IMAGES_EXCLUDE_PATTERN = "(${KERNEL_IMAGETYPE}|README|\.|.*-image-)"
DEPLOY_IMAGES = "\
    ${@' '.join('${RELEASE_IMAGE}-${MACHINE}.%s' % ext for ext in IMAGE_EXTENSIONS.split())} \
    ${RELEASE_IMAGE}-${MACHINE}.license_manifest \
    ${RELEASE_IMAGE}-${MACHINE}.license_manifest.csv \
    ${KERNEL_IMAGETYPE}* \
    ${EXTRA_IMAGES_ARCHIVE_RELEASE} \
"
DEPLOY_IMAGES[doc] = "List of files from DEPLOY_DIR_IMAGE which will be archived"

# Use IMAGE_EXTENSION_xxx to map image type 'xxx' with real image file
# extension name(s)
IMAGE_EXTENSION_live = "hddimg iso"

# Exclude certain image types from the packaged build.
# This allows us to build in the automated environment for regression,
# general testing or simply for availability of extra image types for
# internal use without necessarily packaging them in the installers.
ARCHIVE_RELEASE_IMAGE_FSTYPES_EXCLUDE ?= ""

python () {
    extensions = set()
    fstypes = d.getVar('IMAGE_FSTYPES', True).split()
    fstypes_exclude = d.getVar('ARCHIVE_RELEASE_IMAGE_FSTYPES_EXCLUDE', True).split()
    for type in fstypes:
        if type in fstypes_exclude:
            continue
        extension = d.getVar('IMAGE_EXTENSION_%s' % type, True) or type
        extensions.add(extension)
    d.setVar('IMAGE_EXTENSIONS', ' '.join(sorted(extensions)))

    # Make sure MELDIR is absolute, as we use it in transforms
    d.setVar('MELDIR', os.path.abspath(d.getVar('MELDIR', True)))
}

def uninative_urls(d):
    l = d.createCopy()
    for arch in d.getVar('UNINATIVE_BUILD_ARCHES', True).split():
        chksum = d.getVarFlag("UNINATIVE_CHECKSUM", arch, True)
        if chksum:
            l.setVar('BUILD_ARCH', arch)
            srcuri = l.expand("${UNINATIVE_URL}${UNINATIVE_TARBALL};sha256sum=%s;unpack=no;subdir=uninative/%s" % (chksum, chksum))
            yield srcuri


release_tar () {
    if [ -z ${BINARY_ARTIFACTS_COMPRESSION} ]; then
        COMPRESSION=""
    elif [ ${BINARY_ARTIFACTS_COMPRESSION} = ".bz2" ]; then
        COMPRESSION="-j"
    elif [ ${BINARY_ARTIFACTS_COMPRESSION} = ".xz" ]; then
        COMPRESSION="-J"
    elif [ ${BINARY_ARTIFACTS_COMPRESSION} = ".gz" ]; then
        COMPRESSION="-z"
    else
        bbfatal "Invalid binary artifacts compression type ${BINARY_ARTIFACTS_COMPRESSION}"
    fi

    tar --absolute-names $COMPRESSION "$@" --exclude=.svn \
        --exclude=.git --exclude=\*.pyc --exclude=\*.pyo --exclude=.gitignore \
        -v --show-stored-names
}

git_tar () {
    path="$1"
    shift
    name="$1"
    shift
    rel="${path##*/}"

    if [ -e "$path/.git" ]; then
        if [ "${@oe.data.typed_value('RELEASE_USE_TAGS', d)}" = "True" ]; then
            version="$(git --git-dir="$path/.git" describe --tags)"
        else
            version="$(git --git-dir="$path/.git" rev-list HEAD | wc -l)"
        fi
        git --git-dir=$path/.git archive --format=tar --prefix="${rel:-.}/" HEAD | bzip2 >deploy/${name}_${version}.tar.bz2
    else
        if repo_root "$path" | grep -q '^${MELDIR}/'; then
            if [ "${@oe.data.typed_value('RELEASE_USE_TAGS', d)}" = "True" ]; then
                version=$(cd "$path" && git describe --tags)
            else
                version=$(cd "$path" && git rev-list HEAD . | wc -l)
            fi
            release_tar $path "$@" -cjf deploy/${name}_${version}.tar.bz2
        else
            release_tar $path "$@" -cjf deploy/$name.tar.bz2
        fi
    fi
}

repo_root () {
    git_root=$(cd $1 && git rev-parse --show-toplevel 2>/dev/null)
    # There's a chance this repo could be the overall environment
    # repository, not the layer repository, so just grab the layer
    # if the repo has submodules
    if [ -n "$git_root" ] && [ ! -e $git_root/.gitmodules ]; then
        echo $(cd $git_root && pwd)
        return
    fi

    rel=${1#${MELDIR}/}
    case "$rel" in
        /*)
            echo "$1"
            ;;
        *)
            echo "${MELDIR}/${rel%%/*}"
            ;;
    esac
}
repo_root[vardepsexclude] += "1#${MELDIR}/ rel%%/*"

bb_layers () {
    # Workaround shell function dependency issue
    if false; then
        repo_root
    fi

    for layer in ${BBLAYERS}; do
        layer="${layer%/}"

        topdir="$(repo_root "$layer")"
        repo_name="${topdir##*/}"

        layer_relpath="${layer#${topdir}/}"
        if [ "$layer_relpath" = "$topdir" ]; then
            layer_relpath=$repo_name
        else
            layer_relpath=$repo_name/$layer_relpath
        fi

        if echo "${SUBLAYERS_INDIVIDUAL_ONLY}" | grep -qw "$layer"; then
            printf "%s %s %s\n" "$layer" "$layer_relpath" "$(echo "$layer_relpath" | tr / _)"
        elif echo "${SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL}" | grep -qw "$layer"; then
            printf "%s %s\n" "$layer" "${layer##*/}"
        else
            printf "%s %s\n" "$topdir" "$layer_relpath"
        fi
    done
}
bb_layers[vardepsexclude] += "layer%/ topdir##*/ layer#${topdir}/"

prepare_templates () {
    cp ${TEMPLATECONF}/conf-notes.txt .
    sed 's,^MACHINE ??=.*,MACHINE ??= "${MACHINE}",' ${TEMPLATECONF}/local.conf.sample >local.conf.sample
    if [ -n "${DISTRO}" ]; then
        sed -i 's,^DISTRO =.*,DISTRO = "${DISTRO}",' local.conf.sample
    fi

    sourcery_version="$(echo ${SOURCERY_VERSION} | sed 's/-.*$//')"
    if [ -n "$sourcery_version" ]; then
        sed -i "s,^#*\(SOURCERY_VERSION_REQUIRED =\).*,\1 \"$sourcery_version\"," local.conf.sample
    fi

    pdk_version="${PDK_DISTRO_VERSION}"
    if [ -n "$pdk_version" ]; then
        echo >>local.conf.sample
        echo "PDK_DISTRO_VERSION = \"$pdk_version\"" >>local.conf.sample
    fi

    sed -n '/^BBLAYERS/{n; :start; /\\$/{n; b start}; /^ *"$/d; :done}; p' ${TEMPLATECONF}/bblayers.conf.sample >bblayers.conf.sample
    echo 'BBLAYERS = "\' >>bblayers.conf.sample
    bb_layers | while read path relpath name; do
        printf '    $%s%s \\\n' '{MELDIR}/' "$relpath" >>bblayers.conf.sample
    done
    echo '"' >>bblayers.conf.sample
}

do_prepare_release () {
    mkdir -p deploy

    if echo "${RELEASE_ARTIFACTS}" | grep -qw layers; then
        >deploy/${MACHINE}-layers.txt
        bb_layers | while read path relpath name; do
            echo "$relpath" >>deploy/${MACHINE}-layers.txt
        done

        bb_layers | sort -k1,1 -u | while read path relpath name; do
            if [ -z "$name" ]; then
                name="${path##*/}"
            fi

            if echo "${SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL}" | grep -qw "$path"; then
                # Grab the entire toplevel dir for non-individually-archived
                # sub-layers
                git_tar "$path" "$name" "--transform=s,^$path,$name,"
            else
                git_tar "$path" "$name" "--transform=s,^$path,$relpath,"
            fi
        done
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw bitbake; then
        bitbake_dir="$(which bitbake)"
        found_bitbake=0
        bb_layers >bblayers_for_bitbake
        while read path _ _; do
            case "$bitbake_dir" in
                $path/*)
                    found_bitbake=1
                    break
                    ;;
            esac
        done <bblayers_for_bitbake
        rm bblayers_for_bitbake

        if [ $found_bitbake -eq 0 ]; then
            # Likely using separate bitbake rather than poky
            bitbake_path="$(repo_root $(dirname $(which bitbake))/..)"
            git_tar "$bitbake_path" bitbake "--transform=s,^$bitbake_path,${bitbake_path##*/},"
        fi
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw downloads; then
        rm -f deploy/*-downloads.tar

        for layer in ${BBLAYERS}; do
            ${@bb.utils.which('${BBPATH}', '../scripts/bb-print-layer-data')} "$layer/conf/layer.conf"
        done 2>/dev/null | sed -n 's/^\([^:]*\):[^|]*|\([^|]*\)|.*/\1|\2/p' >layermap.txt

        mkdir -p downloads
        if [ -e ${WORKDIR}/uninative ]; then
            cp -a ${WORKDIR}/uninative downloads/
            # We symlink to the root of downloads so the downloads dir can be
            # used either as a mirror or directly as the DL_DIR
            (cd downloads && find uninative -type f -print0 | xargs -0 -I"{}" sh -c 'touch "{}.done"; ln -s "{}" .; ln -s "{}.done" .')
        fi

        if [ "${ARCHIVE_RELEASE_DL_TOPDIR}" != "${ARCHIVE_RELEASE_DL_DIR}" ]; then
            for dir in ${ARCHIVE_RELEASE_DL_TOPDIR}/*; do
                name=$(basename $dir)
                mkdir -p downloads/$name
                find -L $dir -type f -maxdepth 2 | while read source; do
                    source_name="$(basename "$source")"
                    if [ -e "${DL_DIR}/$source_name" ]; then
                        ln -sf "${DL_DIR}/$source_name" "downloads/$name/$source_name"
                        touch "downloads/$name/$source_name.done"
                    fi
                done
                cd downloads/$name
                for file in ${RELEASE_EXCLUDED_SOURCES}; do
                    rm -f "$file"
                done
                cd - >/dev/null
                layerpath="$(sed -n "s/^$name|//p" layermap.txt)" || exit 1
                layerroot="$(repo_root "$layerpath")"
                layerbase="${layerroot##*/}"
                if echo "${LAYERS_OWN_DOWNLOADS}" | grep -Eq "\<$name\>"; then
                    layer_relpath="${layerpath#${layerroot}/}"
                    if [ "$layer_relpath" = "$layerroot" ]; then
                        layer_relpath=$layerbase
                    else
                        layer_relpath=$layerbase/$layer_relpath
                    fi
                    release_tar "--transform=s,^downloads/$name,$layer_relpath/downloads," -chf \
                            deploy/$name-downloads.tar${BINARY_ARTIFACTS_COMPRESSION} downloads/$name
                else
                    release_tar "--transform=s,^downloads/$name,downloads," -rhf \
                            deploy/$layerbase-downloads.tar${BINARY_ARTIFACTS_COMPRESSION} downloads/$name
                fi
            done
            if [ -n "${UNINATIVE_TARBALL}" ]; then
                release_tar -chf deploy/${MACHINE}-downloads.tar${BINARY_ARTIFACTS_COMPRESSION} downloads/uninative $(find downloads/uninative -type f | sed 's,^.*/,downloads/,')
            fi
        else
            mkdir -p downloads
            find -L ${ARCHIVE_RELEASE_DL_DIR} -type f -maxdepth 2 | while read source; do
                source_name="$(basename "$source")"
                if [ -e "${DL_DIR}/$source_name" ]; then
                    ln -sf "${DL_DIR}/$source_name" "downloads/$source_name"
                    touch "downloads/$source_name.done"
                fi
            done
            cd downloads
            for file in ${RELEASE_EXCLUDED_SOURCES}; do
                rm -f "$file"
            done
            cd - >/dev/null
            release_tar -chf deploy/${MACHINE}-downloads.tar${BINARY_ARTIFACTS_COMPRESSION} downloads/
        fi
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw sstate; then
        # Kill dead links
        find ${ARCHIVE_SSTATE_DIR} -type l | while read fn; do
            if [ ! -e "$fn" ]; then
                rm -f "$fn"
            fi
        done
        release_tar "--transform=s,^${ARCHIVE_SSTATE_DIR},cached-binaries," --exclude=\*.done \
                -chf deploy/${MACHINE}-sstate.tar${BINARY_ARTIFACTS_COMPRESSION} ${ARCHIVE_SSTATE_DIR}
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw templates; then
        prepare_templates
        cp bblayers.conf.sample local.conf.sample conf-notes.txt deploy/
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw images; then
        if [ -e "${BUILDHISTORY_DIR}" ]; then
            echo "--transform=s,${BUILDHISTORY_DIR},${BINARY_INSTALL_PATH}/buildhistory," >include
            echo ${BUILDHISTORY_DIR} >>include
        fi

        if echo "${RELEASE_ARTIFACTS}" | grep -qw templates; then
            echo "--transform=s,${S}/,${CONF_INSTALL_PATH}/," >>include
            echo "${S}/local.conf.sample" >>include
            echo "${S}/bblayers.conf.sample" >>include
        fi

        echo "--transform=s,-${MACHINE},,i" >>include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${BINARY_INSTALL_PATH}," >>include

        find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 \( -type f -o -type l \) | \
            grep -Ev '^${DEPLOY_DIR_IMAGE}/${DEPLOY_IMAGES_EXCLUDE_PATTERN}' >>include

        # Lock down any autorevs
        buildhistory-collect-srcrevs -p "${BUILDHISTORY_DIR}" >"${WORKDIR}/autorevs.conf"
        if [ -s "${WORKDIR}/autorevs.conf" ]; then
            echo "--transform=s,${WORKDIR}/autorevs.conf,${CONF_INSTALL_PATH}/autorevs.conf," >>include
            echo "${WORKDIR}/autorevs.conf" >>include
        fi

        release_tar --files-from=include -cf deploy/${MACHINE}.tar

        echo "--transform=s,-${MACHINE},,i" >include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${BINARY_INSTALL_PATH}," >>include
        {
            ${@'\n'.join('find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1  -iname "%s" || true' % pattern for pattern in DEPLOY_IMAGES.split())}
        } >>include

        if echo "${OVERRIDES}" | tr ':' '\n' | grep -qx 'qemuall'; then
            ext="$(echo "${IMAGE_EXTENSIONS}" | tr ' ' '\n' | grep -v '^tar' | head -n 1)"
            if [ ! -e "${DEPLOY_DIR_IMAGE}/${RELEASE_IMAGE}-${MACHINE}.$ext" ]; then
                bbfatal "Unable to find image for extension $ext, aborting"
            fi
            if [ -e "${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin" ] || [ -e "${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}.bin" ]; then
                kernel="${KERNEL_IMAGETYPE}.bin"
            else
                kernel="${KERNEL_IMAGETYPE}"
            fi
            sed -e "s/##ROOTFS##/${RELEASE_IMAGE}.$ext/; s/##KERNEL##/$kernel/" ${WORKDIR}/runqemu.in >runqemu
            chmod +x runqemu
            echo ./runqemu >>include
            echo "--transform=s,./runqemu$,${BINARY_INSTALL_PATH}/runqemu," >>include
        fi
        release_tar --files-from=include -rhf deploy/${MACHINE}.tar

        if [ ${BINARY_ARTIFACTS_COMPRESSION} = ".bz2" ]
        then
            bzip2 deploy/${MACHINE}.tar
        elif [ ${BINARY_ARTIFACTS_COMPRESSION} = ".gz" ]
        then
            gzip deploy/${MACHINE}.tar
        fi
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -qw probeconfigs; then
        if [ -d "${PROBECONFIGS}" ]; then
            release_tar "--transform=s,${PROBECONFIGS},${PROBECONFIGS_INSTALL_PATH}," -rf deploy/${MACHINE}.tar "${PROBECONFIGS}"
        fi
    fi

    echo ${DISTRO_VERSION} >deploy/distro-version

    mv deploy/* ${DEPLOY_DIR_RELEASE}/
}
addtask prepare_release before do_build after do_patch

do_prepare_release[dirs] =+ "${DEPLOY_DIR_RELEASE} ${MELDIR} ${S}"
do_prepare_release[cleandirs] = "${S}"

# Ensure that all our dependencies are entirely built
do_prepare_release[depends] += "${@bb.utils.contains('RELEASE_ARTIFACTS', 'images', '${RELEASE_IMAGE}:do_${BB_DEFAULT_TASK}', '', d) if '${RELEASE_IMAGE}' else ''}"

# When archiving downloads, make sure they're fetched
FETCHALL_TASK = "${@'do_archive_release_downloads_all' if oe.utils.inherits(d, 'archive-release-downloads') else 'do_fetchall'}"
do_prepare_release[depends] += "${@bb.utils.contains('RELEASE_ARTIFACTS', 'downloads', '${RELEASE_IMAGE}:${FETCHALL_TASK}', '', d) if '${RELEASE_IMAGE}' else ''}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"

python () {
    if not bb.utils.contains('RELEASE_ARTIFACTS', 'sstate', True, False, d):
        # If we aren't packaging sstate, there's no need to suck in all the
        # packaging functions recursively
        d.delVarFlag('do_build', 'recrdeptask')
}
