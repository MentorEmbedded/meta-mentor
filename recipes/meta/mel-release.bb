DESCRIPTION = "Meta package for packaging a Mentor Embedded Linux release"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
INHIBIT_DEFAULT_DEPS = "1"
PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = ""

DEPLOY_DIR_INSTALLER ?= "${DEPLOY_DIR}/release-artifacts"
MEL_RELEASE_IMAGE ?= "core-image-base"
MEL_RELEASE_USE_TAGS ?= "false"
MEL_RELEASE_USE_TAGS[type] = "boolean"

DEPLOY_IMAGE_FILES = "\
    modules-*-${MACHINE}.tgz \
\
"
DEPLOY_IMAGE_LINKS = "\
    u-boot-*${MACHINE}*.bin \
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
    if [ -d $repo/.git ]; then
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

prepare_templates () {
    csl_version="$(echo ${CSL_VER_MAIN} | sed 's/-.*$//')"

    sed 's,^MACHINE ??=.*,MACHINE ??= "${MACHINE}",' ${MELDIR}/meta-mentor/conf/local.conf.sample >local.conf.sample
    sed -i 's,^EXTERNAL_TOOLCHAIN.*,EXTERNAL_TOOLCHAIN ?= "$,' local.conf.sample
    sed -i 's,^\(EXTERNAL_TOOLCHAIN ?= "\$\),\1{MELDIR}/..",' local.conf.sample
    if [ -n "$csl_version" ]; then
        sed -i "s,^#*\(CSL_VER_REQUIRED =\).*,\1 \"$csl_version\"," local.conf.sample
    fi

    sed -n '/^BBLAYERS/{n; :start; /\\$/{n; b start}; /^ *"$/d; :done}; p' ${MELDIR}/meta-mentor/conf/bblayers.conf.sample >bblayers.conf.sample
    echo 'BBLAYERS = "\' >>bblayers.conf.sample
    for layer in ${BBLAYERS}; do
        if ! echo $layer | grep -q "^${MELDIR}/"; then
            continue
        fi
        layer="`echo $layer | sed 's,^${MELDIR}/,,'`"
        printf '    $%s%s \\\n' '{MELDIR}/' "$layer" >>bblayers.conf.sample
    done
    echo '"' >>bblayers.conf.sample
}

do_prepare_release () {
    mkdir -p deploy

    for layer in ${BBLAYERS}; do
        if ! echo $layer | grep -q "^${MELDIR}/"; then
            continue
        fi
        basedir=$(echo $layer|sed 's,^${MELDIR}/,,; s,/.*$,,')
        git_tar ${MELDIR}/$basedir
    done

    mkdir -p downloads
    find -L ${COPYLEFT_SOURCES_DIR} -type f -maxdepth 2 | while read source; do
        src=`readlink $source` || continue
        if echo $src | grep -q "^${DL_DIR}/"; then
            ln -sf $source downloads/
            touch downloads/$(basename $source).done
        fi
    done
    for file in ${SB_RELEASE_EXCLUDED_SOURCES}; do
        rm -f downloads/$file
    done
    mel_tar -cjhf deploy/${MACHINE}-sources.tar.bz2 downloads/

    # Kill dead links
    find ${SSTATE_DIR} -type l | while read fn; do
        if [ ! -e "$fn" ]; then
            rm -f "$fn"
        fi
    done
    mel_tar "--transform=s,^${SSTATE_DIR},cached-binaries," --exclude=\*.done \
            -cjhf deploy/${MACHINE}-sstate.tar.bz2 ${SSTATE_DIR}

    echo "--absolute-names" >include
    echo "--transform=s,-${MACHINE}\.,.," >>include
    echo "--transform=s,${DEPLOY_DIR_IMAGE},${MACHINE}/binary," >>include
    {
        ${@'\n'.join('find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 -type f -iname "%s" || true' % file for file in DEPLOY_IMAGE_FILES.split())}
        ${@'\n'.join('find ${DEPLOY_DIR_IMAGE}/ -maxdepth 1 -type l -iname "%s" || true' % file for file in DEPLOY_IMAGE_LINKS.split())}
    } >>include

    echo "--transform=s,${BUILDHISTORY_DIR},${MACHINE}/binary/buildhistory," >>include
    echo "--transform=s,-${MACHINE},,i" >>include
    echo "--transform=s,${MACHINE},,i" >>include
    echo "--exclude=.git" >>include
    echo ${BUILDHISTORY_DIR} >>include

    prepare_templates

    echo "--transform=s,${S}/,${MACHINE}/conf/," >>include
    echo "${S}/local.conf.sample" >>include
    echo "${S}/bblayers.conf.sample" >>include

    mel_tar --files-from=include -cjhf deploy/${MACHINE}.tar.bz2

    cp bblayers.conf.sample local.conf.sample deploy/
    echo ${DISTRO_VERSION} >deploy/distro-version

    mv deploy/* ${DEPLOY_DIR_INSTALLER}/
}
addtask prepare_release before do_build


do_prepare_release[dirs] =+ "${DEPLOY_DIR_INSTALLER} ${MELDIR} ${S}"
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
