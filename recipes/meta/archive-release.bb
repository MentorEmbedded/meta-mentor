DESCRIPTION = "Archive the artifacts for a ${DISTRO_NAME} release"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
INHIBIT_DEFAULT_DEPS = "1"
PROVIDES += "mel-release"
PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = ""
EXCLUDE_FROM_WORLD = "1"

MELDIR ?= "${COREBASE}/.."
TEMPLATECONF ?= "${FILE_DIRNAME}/../../conf"

# Add a default in case the user doesn't inherit copyleft_compliance
COPYLEFT_SOURCES_DIR ?= "${DL_DIR}"

DUMP_HEADREVS_DB ?= ""
DEPLOY_DIR_RELEASE ?= "${DEPLOY_DIR}/release-artifacts"
RELEASE_ARTIFACTS ?= "layers bitbake templates images downloads sstate"
RELEASE_ARTIFACTS[doc] = "List of artifacts to include (available: layers, bitbake, templates, images, downloads, sstate"
RELEASE_IMAGE ?= "core-image-base"
RELEASE_IMAGE[doc] = "The image to build and archive in this release"
RELEASE_USE_TAGS ?= "false"
RELEASE_USE_TAGS[doc] = "Use git tags rather than just # of commits for layer archive versioning"
RELEASE_USE_TAGS[type] = "boolean"
RELEASE_EXCLUDED_SOURCES ?= ""
RELEASE_EXCLUDED_SOURCES[doc] = "Patterns of files in COPYLEFT_SOURCES_DIR to exclude"

# If we have an isolated set of shared state archives, use that, so as to
# avoid archiving sstates which were unused.
SSTATE_DIR := "${@ISOLATED_SSTATE_DIR \
                 if oe.utils.inherits(d, 'isolated-sstate-dir') else SSTATE_DIR}"

# Kernel images and filesystems are handled separately, as they produce
# timestamped filenames, and we only want the current ones (symlinked ones).
DEPLOY_IMAGES_EXCLUDE_PATTERN = "(${KERNEL_IMAGETYPE}|README|\.|.*-image-)"
DEPLOY_IMAGES = "\
    ${@' '.join('${RELEASE_IMAGE}-${MACHINE}.%s' % ext for ext in IMAGE_EXTENSIONS.split())} \
    ${RELEASE_IMAGE}-${MACHINE}.license_manifest \
    ${RELEASE_IMAGE}-${MACHINE}.license_manifest.csv \
    ${KERNEL_IMAGETYPE}-${MACHINE}* \
"
DEPLOY_IMAGES[doc] = "List of files from DEPLOY_DIR_IMAGE which will be archived"

# Use IMAGE_EXTENSION_xxx to map image type 'xxx' with real image file
# extension name(s)
IMAGE_EXTENSION_live = "hddimg iso"


python () {
    extensions = set()
    fstypes = d.getVar('IMAGE_FSTYPES', True).split()
    for type in fstypes:
        extension = d.getVar('IMAGE_EXTENSION_%s' % type, True) or type
        extensions.add(extension)
    d.setVar('IMAGE_EXTENSIONS', ' '.join(extensions))

    if 'live' in fstypes:
        d.appendVarFlag('do_prepare_release', 'depends', ' ${RELEASE_IMAGE}:do_bootimg')

    # Make sure MELDIR is absolute, as we use it in transforms
    d.setVar('MELDIR', os.path.abspath(d.getVar('MELDIR', True)))
}

release_tar () {
    tar --absolute-names "$@" "--transform=s,^${MELDIR}/,," --exclude=.svn \
        --exclude=.git --exclude=\*.pyc --exclude=\*.pyo --exclude=.gitignore \
        -v --show-stored-names
}

git_tar () {
    repo=$1
    shift
    name=`basename $repo`
    if [ -e $repo/.git ]; then
        if [ "${@oe.data.typed_value('RELEASE_USE_TAGS', d)}" == "True" ]; then
            version=$(git --git-dir=$repo/.git describe --tags)
        else
            version=$(git --git-dir=$repo/.git rev-list HEAD | wc -l)
        fi
        release_tar $repo "$@" "--transform=s,^$repo,$name," -cjf deploy/${name}_$version.tar.bz2
    else
        release_tar $repo "$@" "--transform=s,^$repo,$name," -cjf deploy/$name.tar.bz2
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
        printf "%s %s\n" "$topdir" "$layer_relpath"
    done
}

prepare_templates () {
    csl_version="$(echo ${CSL_VER_MAIN} | sed 's/-.*$//')"

    sed 's,^MACHINE ??=.*,MACHINE ??= "${MACHINE}",' ${TEMPLATECONF}/local.conf.in >local.conf.in
    sed -i 's,^#\?EXTERNAL_TOOLCHAIN.*,EXTERNAL_TOOLCHAIN ?= "$,' local.conf.in
    sed -i 's,^\(EXTERNAL_TOOLCHAIN ?= "\$\),\1{MELDIR}/..",' local.conf.in
    if [ -n "$csl_version" ]; then
        sed -i "s,^#*\(CSL_VER_REQUIRED =\).*,\1 \"$csl_version\"," local.conf.in
    fi
    {
        echo
        echo '# Prefer the cached upstream SCM revisions'
        echo 'BB_SRCREV_POLICY = "cache"'
    } >>local.conf.in

    sed -n '/^BBLAYERS/{n; :start; /\\$/{n; b start}; /^ *"$/d; :done}; p' ${TEMPLATECONF}/bblayers.conf.in >bblayers.conf.in
    echo 'BBLAYERS = "\' >>bblayers.conf.in
    bb_layers | while read path relpath; do
        printf '    $%s%s \\\n' '{MELDIR}/' "$relpath" >>bblayers.conf.in
    done
    echo '"' >>bblayers.conf.in
}

do_prepare_release () {
    mkdir -p deploy

    if echo "${RELEASE_ARTIFACTS}" | grep -w layers; then
        >deploy/${MACHINE}-layers.txt
        bb_layers | cut -d" " -f1 | sort -u | while read path; do
            basename $path >>deploy/${MACHINE}-layers.txt
            git_tar $path
        done
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -w bitbake; then
        found_bitbake=0
        bb_layers | while read path _; do
            case "$bitbake_dir" in
                $path/*)
                    found_bitbake=1
                    break
                    ;;
            esac
        done
        if [ $found_bitbake -eq 0 ]; then
            # Likely using separate bitbake rather than poky
            git_tar "$(repo_root $(dirname $(which bitbake))/..)"
        fi
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -w downloads; then
        mkdir -p downloads
        find -L ${COPYLEFT_SOURCES_DIR} -type f -maxdepth 2 | while read source; do
            src=`readlink $source` || continue
            if echo $src | grep -q "^${DL_DIR}/"; then
                ln -sf $source downloads/
                touch downloads/$(basename $source).done
            fi
        done
        for file in ${RELEASE_EXCLUDED_SOURCES}; do
            rm -f downloads/$file
        done
        release_tar -cjhf deploy/${MACHINE}-sources.tar.bz2 downloads/
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -w sstate; then
        # Kill dead links
        find ${SSTATE_DIR} -type l | while read fn; do
            if [ ! -e "$fn" ]; then
                rm -f "$fn"
            fi
        done
        release_tar "--transform=s,^${SSTATE_DIR},cached-binaries," --exclude=\*.done \
                -cjhf deploy/${MACHINE}-sstate.tar.bz2 ${SSTATE_DIR}
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -w templates; then
        prepare_templates
        cp bblayers.conf.in local.conf.in deploy/
    fi

    if echo "${RELEASE_ARTIFACTS}" | grep -w images; then
        echo "--transform=s,${BUILDHISTORY_DIR},${MACHINE}/binary/buildhistory," >include
        echo ${BUILDHISTORY_DIR} >>include

        if echo "${RELEASE_ARTIFACTS}" | grep -w templates; then
            echo "--transform=s,${S}/,${MACHINE}/conf/," >>include
            echo "${S}/local.conf.in" >>include
            echo "${S}/bblayers.conf.in" >>include
        fi

        echo "--transform=s,-${MACHINE},,i" >>include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${MACHINE}/binary," >>include

        find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 \( -type f -o -type l \) | \
            grep -Ev '^${DEPLOY_DIR_IMAGE}/${DEPLOY_IMAGES_EXCLUDE_PATTERN}' >>include

        if [ -n "${DUMP_HEADREVS_DB}" ]; then
            echo "--transform=s,${WORKDIR}/dumped-headrevs.db,${@DUMP_HEADREVS_DB.replace('${MELDIR}/', '')}," >>include
            echo ${WORKDIR}/dumped-headrevs.db >>include
        fi

        release_tar --files-from=include -cf deploy/${MACHINE}.tar

        echo "--transform=s,-${MACHINE},,i" >include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${MACHINE}/binary," >>include
        {
            ${@'\n'.join('find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 -type l -iname "%s" || true' % pattern for pattern in DEPLOY_IMAGES.split())}
        } >>include
        release_tar --files-from=include -rhf deploy/${MACHINE}.tar

        bzip2 deploy/${MACHINE}.tar
    fi

    echo ${DISTRO_VERSION} >deploy/distro-version

    mv deploy/* ${DEPLOY_DIR_RELEASE}/
}
addtask prepare_release before do_build after do_dump_headrevs

python do_dump_headrevs () {
    dump_headrevs(d, os.path.join(d.getVar('WORKDIR', True), 'dumped-headrevs.db'))
}
addtask dump_headrevs


do_prepare_release[dirs] =+ "${DEPLOY_DIR_RELEASE} ${MELDIR} ${S}"
do_prepare_release[cleandirs] = "${S}"
do_prepare_release[nostamp] = "1"
do_prepare_release[depends] += "tar-replacement-native:do_populate_sysroot"
do_prepare_release[depends] += "${RELEASE_IMAGE}:do_rootfs"
do_prepare_release[depends] += "${RELEASE_IMAGE}:do_build"
do_prepare_release[recrdeptask] += "do_package_write"
do_prepare_release[recrdeptask] += "do_populate_sysroot"

python () {
    if oe.utils.inherits(d, 'copyleft_compliance'):
        d.appendVarFlag('do_prepare_release', 'recrdeptask',
                        ' do_prepare_copyleft_sources')
}

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
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
