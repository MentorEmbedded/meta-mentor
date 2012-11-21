DESCRIPTION = "Meta package for packaging a Mentor Embedded Linux release"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
INHIBIT_DEFAULT_DEPS = "1"
PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = ""
EXCLUDE_FROM_WORLD = "1"

MELDIR ?= "${COREBASE}/.."
META_MENTOR_PATH = "${FILE_DIRNAME}/../.."

DEPLOY_DIR_RELEASE ?= "${DEPLOY_DIR}/release-artifacts"
MEL_RELEASE_ARTIFACTS ?= "layers bitbake templates images downloads sstate"
MEL_RELEASE_IMAGE ?= "core-image-base"
MEL_RELEASE_USE_TAGS ?= "false"
MEL_RELEASE_USE_TAGS[type] = "boolean"

# If we have an isolated set of shared state archives, use that, so as to
# avoid archiving sstates which were unused.
SSTATE_DIR := "${@ISOLATED_SSTATE_DIR \
                 if oe.utils.inherits(d, 'isolated-sstate-dir') else SSTATE_DIR}"

# Kernel images and filesystems are handled separately, as they produce
# timestamped filenames, and we only want the current ones (symlinked ones).
DEPLOY_IMAGES_EXCLUDE_PATTERN = "(${KERNEL_IMAGETYPE}|README|\.|.*-image-)"
DEPLOY_IMAGES = "\
    ${@' '.join('${MEL_RELEASE_IMAGE}-${MACHINE}.%s' % ext for ext in IMAGE_EXTENSIONS.split())} \
    ${MEL_RELEASE_IMAGE}-${MACHINE}.license_manifest \
    ${MEL_RELEASE_IMAGE}-${MACHINE}.license_manifest.csv \
    ${KERNEL_IMAGETYPE}-${MACHINE}* \
"

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
        d.appendVarFlag('do_prepare_release', 'depends', ' ${MEL_RELEASE_IMAGE}:do_bootimg')

    # Make sure MELDIR is absolute, as we use it in transforms
    d.setVar('MELDIR', os.path.abspath(d.getVar('MELDIR', True)))
}

mel_tar () {
    tar --absolute-names "$@" "--transform=s,^${MELDIR}/,," --exclude=.svn \
        --exclude=.git --exclude=\*.pyc --exclude=\*.pyo --exclude=.gitignore \
        -v --show-stored-names
}

git_tar () {
    repo=$1
    shift
    name=`basename $repo`
    if [ -e $repo/.git ]; then
        if [ "${@oe.data.typed_value('MEL_RELEASE_USE_TAGS', d)}" == "True" ]; then
            version=$(git --git-dir=$repo/.git describe --tags)
        else
            version=$(git --git-dir=$repo/.git rev-list HEAD | wc -l)
        fi
        mel_tar $repo "$@" "--transform=s,^$repo,$name," -cjf deploy/${name}_$version.tar.bz2
    else
        mel_tar $repo "$@" "--transform=s,^$repo,$name," -cjf deploy/$name.tar.bz2
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

    sed 's,^MACHINE ??=.*,MACHINE ??= "${MACHINE}",' ${META_MENTOR_PATH}/conf/local.conf.sample >local.conf.sample
    sed -i 's,^EXTERNAL_TOOLCHAIN.*,EXTERNAL_TOOLCHAIN ?= "$,' local.conf.sample
    sed -i 's,^\(EXTERNAL_TOOLCHAIN ?= "\$\),\1{MELDIR}/..",' local.conf.sample
    if [ -n "$csl_version" ]; then
        sed -i "s,^#*\(CSL_VER_REQUIRED =\).*,\1 \"$csl_version\"," local.conf.sample
    fi

    sed -n '/^BBLAYERS/{n; :start; /\\$/{n; b start}; /^ *"$/d; :done}; p' ${META_MENTOR_PATH}/conf/bblayers.conf.sample >bblayers.conf.sample
    echo 'BBLAYERS = "\' >>bblayers.conf.sample
    bb_layers | while read path relpath; do
        printf '    $%s%s \\\n' '{MELDIR}/' "$relpath" >>bblayers.conf.sample
    done
    echo '"' >>bblayers.conf.sample
}

do_prepare_release () {
    mkdir -p deploy

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w layers; then
        bb_layers | cut -d" " -f1 | sort -u | while read path; do
            git_tar $path
        done
    fi

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w bitbake; then
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

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w downloads; then
        mkdir -p downloads
        find -L ${COPYLEFT_SOURCES_DIR} -type f -maxdepth 2 | while read source; do
            src=`readlink $source` || continue
            if echo $src | grep -q "^${DL_DIR}/"; then
                ln -sf $source downloads/
                touch downloads/$(basename $source).done
            fi
        done
        for file in ${MEL_RELEASE_EXCLUDED_SOURCES}; do
            rm -f downloads/$file
        done
        mel_tar -cjhf deploy/${MACHINE}-sources.tar.bz2 downloads/
    fi

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w sstate; then
        # Kill dead links
        find ${SSTATE_DIR} -type l | while read fn; do
            if [ ! -e "$fn" ]; then
                rm -f "$fn"
            fi
        done
        mel_tar "--transform=s,^${SSTATE_DIR},cached-binaries," --exclude=\*.done \
                -cjhf deploy/${MACHINE}-sstate.tar.bz2 ${SSTATE_DIR}
    fi

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w templates; then
        prepare_templates
        cp bblayers.conf.sample local.conf.sample deploy/
    fi

    if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w images; then
        echo "--transform=s,${BUILDHISTORY_DIR},${MACHINE}/binary/buildhistory," >include
        echo ${BUILDHISTORY_DIR} >>include

        if echo "${MEL_RELEASE_ARTIFACTS}" | grep -w templates; then
            echo "--transform=s,${S}/,${MACHINE}/conf/," >>include
            echo "${S}/local.conf.sample" >>include
            echo "${S}/bblayers.conf.sample" >>include
        fi

        echo "--transform=s,-${MACHINE},,i" >>include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${MACHINE}/binary," >>include

        find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 \( -type f -o -type l \) | \
            grep -Ev '^${DEPLOY_DIR_IMAGE}/${DEPLOY_IMAGES_EXCLUDE_PATTERN}' >>include

        mel_tar --files-from=include -cf deploy/${MACHINE}.tar

        echo "--transform=s,-${MACHINE},,i" >include
        echo "--transform=s,${DEPLOY_DIR_IMAGE},${MACHINE}/binary," >>include
        {
            ${@'\n'.join('find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 -type l -iname "%s" || true' % pattern for pattern in DEPLOY_IMAGES.split())}
        } >>include
        mel_tar --files-from=include -rhf deploy/${MACHINE}.tar

        bzip2 deploy/${MACHINE}.tar
    fi

    echo ${DISTRO_VERSION} >deploy/distro-version

    mv deploy/* ${DEPLOY_DIR_RELEASE}/
}
addtask prepare_release before do_build


do_prepare_release[dirs] =+ "${DEPLOY_DIR_RELEASE} ${MELDIR} ${S}"
do_prepare_release[cleandirs] = "${S}"
do_prepare_release[nostamp] = "1"
do_prepare_release[depends] += "tar-replacement-native:do_populate_sysroot"
do_prepare_release[depends] += "${MEL_RELEASE_IMAGE}:do_rootfs"
do_prepare_release[depends] += "${MEL_RELEASE_IMAGE}:do_build"
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
do_package_write[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"
