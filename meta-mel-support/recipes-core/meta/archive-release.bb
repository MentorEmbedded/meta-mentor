# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

DESCRIPTION = "Archive the artifacts for a ${DISTRO_NAME} release"
LICENSE = "MIT"
INHIBIT_DEFAULT_DEPS = "1"
PACKAGE_ARCH = "${MACHINE_ARCH}"
EXCLUDE_FROM_WORLD = "1"

SRC_URI += "${@' '.join(uninative_urls(d)) if 'downloads' in '${RELEASE_ARTIFACTS}'.split() else ''}"
SRC_URI += "https://github.com/01org/bmap-tools/releases/download/v3.4/bmaptool;name=bmaptool"
SRC_URI[bmaptool.md5sum] = "7bc226c2b15aff58af31e421fa381d34"
SRC_URI[bmaptool.sha256sum] = "8cedbb7a525dd4026b6cafe11f496de11dbda0f0e76a5b4938d2687df67bab7f"
SRC_URI:append:qemuall = " file://runqemu.in"

# We're using image fstypes data, inherit the class in case variables from it
# are needed for IMAGE_FSTYPES
inherit image_types nopackages

UNINATIVE_BUILD_ARCHES ?= "x86_64 i686"
MELDIR ?= "${COREBASE}/.."
TEMPLATECONF_STR ?= "${@(oe.utils.read_file('${TOPDIR}/conf/templateconf.cfg') or '${FILE_DIRNAME}/../../../conf').rstrip()}"
TEMPLATECONF = "${@os.path.join('${COREBASE}', '${TEMPLATECONF_STR}')}"

BSPFILES_INSTALL_PATH ?= "${MACHINE}"
BINARY_INSTALL_PATH ?= "${BSPFILES_INSTALL_PATH}/binary"
CONF_INSTALL_PATH ?= "${BSPFILES_INSTALL_PATH}/conf"

# Add a default in case the user doesn't inherit copyleft_compliance
ARCHIVE_RELEASE_DL_DIR ?= "${DL_DIR}"
ARCHIVE_RELEASE_DL_TOPDIR ?= "${ARCHIVE_RELEASE_DL_DIR}"

# Default to shipping update-* as individual artifacts
def configured_update_layers(d):
    """Return the configured layers whose basenames are update-*"""
    update_layers = set()
    for layer in d.getVar('BBLAYERS').split():
        basename = os.path.basename(layer)
        if basename.startswith('update-'):
            update_layers.add(layer)
    return ' '.join(sorted(update_layers))

# Sub-layers to archive individually, rather than grabbing the entire
# repository they're in
def layers_by_name(d, *layers):
    for l in layers:
        v = d.getVar('LAYERDIR_%s' % l)
        if v:
            yield v

SUBLAYERS_INDIVIDUAL_ONLY ?= ""
SUBLAYERS_INDIVIDUAL_ONLY_TOPLEVEL ?= "${@configured_update_layers(d)}"

DEPLOY_DIR_RELEASE ?= "${DEPLOY_DIR}/release-artifacts"
RELEASE_ARTIFACTS ?= "layers bitbake templates images downloads"
RELEASE_ARTIFACTS[doc] = "List of artifacts to include (available: layers, bitbake, templates, images, downloads"
RELEASE_IMAGE ?= "core-image-base"
RELEASE_IMAGE[doc] = "The image to build and archive in this release"
RELEASE_USE_TAGS ?= "false"
RELEASE_USE_TAGS[doc] = "Use git tags rather than just # of commits for layer archive versioning"
RELEASE_USE_TAGS[type] = "boolean"
RELEASE_EXCLUDED_SOURCES ?= ""
RELEASE_EXCLUDED_SOURCES[doc] = "Patterns of files in ARCHIVE_RELEASE_DL_DIR to exclude"
BINARY_ARTIFACTS_COMPRESSION ?= ""
BINARY_ARTIFACTS_COMPRESSION[doc] = "Compression type for images and downloads artifacts.\
 Available: '.bz2' and '.gz'. No compression if empty"

LAYERS_OWN_DOWNLOADS ?= "${@' '.join(l for l in '${BBFILE_COLLECTIONS}'.split() if l.startswith('update-'))}"
LAYERS_OWN_DOWNLOADS[doc] = "Names of layers whose downloads should be shipped inside the layer itself, self contained."

IMAGE_BASENAME = "${RELEASE_IMAGE}"
IMAGE_LINK_NAME ?= "${IMAGE_BASENAME}-${MACHINE}"
IMAGE_NAME_SUFFIX ?= ".rootfs"
EXTRA_IMAGES_ARCHIVE_RELEASE ?= ""
DEPLOY_IMAGES ?= "\
    ${@' '.join('${IMAGE_LINK_NAME}.%s' % ext for ext in d.getVar('IMAGE_EXTENSIONS').split())} \
    ${IMAGE_LINK_NAME}.license_manifest \
    ${IMAGE_LINK_NAME}.license_manifest.csv \
    ${EXTRA_IMAGES_ARCHIVE_RELEASE} \
"
DEPLOY_IMAGES:append:qemuall = "${@' ' + d.getVar('KERNEL_IMAGETYPE') if 'wic' not in d.getVar('IMAGE_EXTENSIONS') else ''}"
DEPLOY_IMAGES[doc] = "List of files from DEPLOY_DIR_IMAGE which will be archived"

# Use IMAGE_EXTENSION_xxx to map image type 'xxx' with real image file
# extension name(s)
IMAGE_EXTENSION_live = "hddimg iso"

# Exclude certain image types from the packaged build.
# This allows us to build in the automated environment for regression,
# general testing or simply for availability of extra image types for
# internal use without necessarily packaging them in the installers.
ARCHIVE_RELEASE_IMAGE_FSTYPES_EXCLUDE ?= "tar.gz tar.bz2"

def image_extensions(d):
    extensions = set()
    fstypes = d.getVar('IMAGE_FSTYPES').split()
    fstypes_exclude = d.getVar('ARCHIVE_RELEASE_IMAGE_FSTYPES_EXCLUDE').split()
    for type in fstypes:
        if type in fstypes_exclude:
            continue
        extension = d.getVar('IMAGE_EXTENSION_%s' % type) or type
        extensions.add(extension)
    return ' '.join(sorted(extensions))
    d.setVar('IMAGE_EXTENSIONS', ' '.join(sorted(extensions)))

# If a wic image is enabled, that's all we want
IMAGE_EXTENSIONS_FULL = "${@image_extensions(d)}"
IMAGE_EXTENSIONS_WIC = "${@' '.join(e for e in d.getVar('IMAGE_EXTENSIONS_FULL').split() if 'wic' in e)}"
IMAGE_EXTENSIONS ?= "${@d.getVar('IMAGE_EXTENSIONS_WIC') if d.getVar('IMAGE_EXTENSIONS_WIC') else d.getVar('IMAGE_EXTENSIONS_FULL')}"

python () {
    # Make sure MELDIR is absolute, as we use it in transforms
    d.setVar('MELDIR', os.path.abspath(d.getVar('MELDIR')))

    for component in d.getVar('RELEASE_ARTIFACTS').split():
        ctask = 'do_archive_%s' % component
        if ctask not in d:
            bb.fatal('do_archive_release: no such task "%s" for component "%s" listed in RELEASE_ARTIFACTS' % (ctask, component))

        bb.build.addtask(ctask, 'do_prepare_release', 'do_patch do_prepare_recipe_sysroot', d)
        d.setVar('SSTATE_SKIP_CREATION:task-archive-%s' % component.replace('_', '-'), '1')
        d.setVarFlag(ctask, 'umask', '022')
        d.setVarFlag(ctask, 'dirs', '${S}/%s' % ctask)
        d.setVarFlag(ctask, 'cleandirs', '${S}/%s' % ctask)
        d.setVarFlag(ctask, 'sstate-inputdirs', '${S}/%s' % ctask)
        d.setVarFlag(ctask, 'sstate-outputdirs', '${DEPLOY_DIR_RELEASE}')
        d.setVarFlag(ctask, 'stamp-extra-info', '${MACHINE}')
        d.appendVarFlag(ctask, 'postfuncs', ' compress_binary_artifacts')
}

def uninative_urls(d):
    l = d.createCopy()
    for arch in d.getVar('UNINATIVE_BUILD_ARCHES').split():
        chksum = d.getVarFlag("UNINATIVE_CHECKSUM", arch)
        if chksum:
            l.setVar('BUILD_ARCH', arch)
            srcuri = l.expand("${UNINATIVE_URL}${UNINATIVE_TARBALL};sha256sum=%s;unpack=no;subdir=uninative/%s;downloadfilename=uninative/%s/${UNINATIVE_TARBALL}" % (chksum, chksum, chksum))
            yield srcuri

release_tar () {
    tar --absolute-names --exclude=.svn \
        --exclude=.git --exclude=\*.pyc --exclude=\*.pyo --exclude=.gitignore "$@"  \
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
        git --git-dir=$path/.git archive --format=tar --prefix="${rel:-.}/" HEAD | bzip2 >${name}_${version}.tar.bz2
    else
        if repo_root "$path" | grep -q '^${MELDIR}/'; then
            if [ "${@oe.data.typed_value('RELEASE_USE_TAGS', d)}" = "True" ]; then
                version=$(cd "$path" && git describe --tags)
            else
                version=$(cd "$path" && git rev-list HEAD . | wc -l)
            fi
            release_tar $path "$@" -cjf ${name}_${version}.tar.bz2
        else
            release_tar $path "$@" -cjf $name.tar.bz2
        fi
    fi
}
# Workaround shell function dependency issue
git_tar[vardeps] += "repo_root"

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
# Workaround shell function dependency issue
bb_layers[vardeps] += "repo_root"
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

do_archive_layers () {
    >${MACHINE}-layers.txt
    bb_layers | while read path relpath name; do
        echo "$relpath" >>${MACHINE}-layers.txt
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
}

do_archive_downloads () {
    for layer in ${BBLAYERS}; do
        ${@bb.utils.which('${BBPATH}', '../scripts/bb-print-layer-data')} "$layer/conf/layer.conf"
    done 2>/dev/null | sed -n 's/^\([^:]*\):[^|]*|\([^|]*\)|.*/\1|\2/p' >layermap.txt

    mkdir -p downloads
    if [ -e ${WORKDIR}/uninative ]; then
        cp -a ${WORKDIR}/uninative downloads/
        # We symlink to the root of downloads so the downloads dir can be
        # used either as a mirror or directly as the DL_DIR
        (cd downloads && find uninative -type f -print0 | xargs -0 -I"{}" sh -c 'touch "{}.done"; ln -sf "{}" .; ln -sf "{}.done" .')
    fi

    if [ "${ARCHIVE_RELEASE_DL_TOPDIR}" != "${ARCHIVE_RELEASE_DL_DIR}" ]; then
        for dir in ${ARCHIVE_RELEASE_DL_TOPDIR}/*/; do
            dir="${dir%/}"
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
            if [ -n "$layerpath" ]; then
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
                            $name-downloads.tar downloads/$name
                else
                    release_tar "--transform=s,^downloads/$name,downloads," -rhf \
                            $layerbase-downloads.tar downloads/$name
                fi
            fi
        done
        if [ -n "${UNINATIVE_TARBALL}" ]; then
            release_tar -chf ${MACHINE}-downloads.tar downloads/uninative $(find downloads/uninative -type f | sed 's,^.*/,downloads/,')
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
        release_tar -chf ${MACHINE}-downloads.tar downloads/
    fi
    rm -rf downloads layermap.txt
}
# Workaround shell function dependency issue
do_archive_downloads[vardeps] += "repo_root"
addtask archive_downloads after do_fetch

do_archive_bitbake () {
    bitbake_dir="$(which bitbake)"
    bitbake_via_layers=0
    bb_layers | while read -r path _; do
        case "$bitbake_dir" in
            $path/*)
                return
                ;;
        esac
    done

    bitbake_path="$(repo_root $(dirname $(which bitbake))/..)"
    git_tar "$bitbake_path" bitbake "--transform=s,^$bitbake_path,${bitbake_path##*/},"
}

do_archive_images () {
    echo "--transform=s,-${MACHINE},,i" >include
    echo "--transform=s,${DEPLOY_DIR_IMAGE},${BINARY_INSTALL_PATH}," >>include

    for filename in ${DEPLOY_IMAGES}; do
        echo "${DEPLOY_DIR_IMAGE}/$filename" >>include
    done

    # Lock down any autorevs
    if [ -e "${BUILDHISTORY_DIR}" ]; then
        buildhistory-collect-srcrevs -p "${BUILDHISTORY_DIR}" >"${WORKDIR}/autorevs.conf"
        if [ -s "${WORKDIR}/autorevs.conf" ]; then
            echo "--transform=s,${WORKDIR}/autorevs.conf,${CONF_INSTALL_PATH}/autorevs.conf," >>include
            echo "${WORKDIR}/autorevs.conf" >>include
        fi
    fi

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
        echo "--transform=s,runqemu,${BINARY_INSTALL_PATH}/runqemu," >>include
        echo runqemu >>include
    fi
    if echo "${RELEASE_ARTIFACTS}" | grep -qw templates; then
        prepare_templates
        echo "--transform=s,$PWD/,${CONF_INSTALL_PATH}/," >>include
        echo "$PWD/local.conf.sample" >>include
        echo "$PWD/bblayers.conf.sample" >>include
        echo "$PWD/conf-notes.txt" >>include
    fi

    if [ -e "${DEPLOY_DIR_IMAGE}/${RELEASE_IMAGE}-${MACHINE}.qemuboot.conf" ]; then
        cp "${DEPLOY_DIR_IMAGE}/${RELEASE_IMAGE}-${MACHINE}.qemuboot.conf" ${WORKDIR}/qemuboot.conf
        sed -i -e 's,-${MACHINE},,g' ${WORKDIR}/qemuboot.conf
        echo "--transform=s,${WORKDIR}/qemuboot.conf,${BINARY_INSTALL_PATH}/${RELEASE_IMAGE}.qemuboot.conf," >>include
        echo "${WORKDIR}/qemuboot.conf" >>include
    fi

    if [ -n "${XLAYERS}" ]; then
        for layer in ${XLAYERS}; do
            echo "$layer"
        done \
            | sort -u >"${WORKDIR}/xlayers.conf"
    fi
    if [ -e "${WORKDIR}/xlayers.conf" ]; then
        echo "--transform=s,${WORKDIR}/xlayers.conf,${BSPFILES_INSTALL_PATH}/xlayers.conf," >>include
        echo "${WORKDIR}/xlayers.conf" >>include
    fi

    chmod +x "${WORKDIR}/bmaptool"
    echo "--transform=s,${WORKDIR}/bmaptool,${BINARY_INSTALL_PATH}/bmaptool," >>include
    echo "${WORKDIR}/bmaptool" >>include
    release_tar --files-from=include -chf ${MACHINE}-${ARCHIVE_RELEASE_VERSION}.tar
}

do_archive_templates () {
    if ! echo "${RELEASE_ARTIFACTS}" | grep -qw images; then
        prepare_templates
    fi
}

do_prepare_release () {
    echo ${DISTRO_VERSION} >distro-version
}

compress_binary_artifacts () {
    for fn in ${MACHINE}*.tar; do
        if [ -e "$fn" ]; then
            if [ ${BINARY_ARTIFACTS_COMPRESSION} = ".bz2" ]; then
                bzip2 "$fn"
            elif [ ${BINARY_ARTIFACTS_COMPRESSION} = ".gz" ]; then
                gzip "$fn"
            fi
        fi
    done
}

SSTATETASKS += "do_prepare_release ${@' '.join('do_archive_%s' % i for i in "${RELEASE_ARTIFACTS}".split())}"

do_prepare_release[dirs] = "${S}/deploy"
do_prepare_release[umask] = "022"
SSTATE_SKIP_CREATION:task-prepare-release = "1"
do_prepare_release[sstate-inputdirs] = "${S}/deploy"
do_prepare_release[sstate-outputdirs] = "${DEPLOY_DIR_RELEASE}"
do_prepare_release[stamp-extra-info] = "${MACHINE}"
addtask do_prepare_release before do_build after do_patch

# Ensure that all our dependencies are entirely built
do_archive_images[depends] += "${@'${RELEASE_IMAGE}:do_${BB_DEFAULT_TASK}' if '${RELEASE_IMAGE}' else ''}"

# When archiving downloads, make sure they're fetched
FETCHALL_TASK = "${@'do_archive_release_downloads_all' if oe.utils.inherits(d, 'archive-release-downloads') else 'do_fetchall'}"
do_archive_downloads[depends] += "${@'${RELEASE_IMAGE}:${FETCHALL_TASK}' if '${RELEASE_IMAGE}' else ''}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot

# This recipe emits no packages, and archives existing buildsystem content and
# output whose licenses are outside our control
deltask populate_lic
