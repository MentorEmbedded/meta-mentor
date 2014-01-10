inherit allarch

SUMMARY = "Operating system identification"
DESCRIPTION = "The /etc/os-release file contains operating system identification data."
LICENSE = "MIT"
INHIBIT_DEFAULT_DEPS = "1"

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"

# Other valid fields: BUILD_ID ANSI_COLOR CPE_NAME HOME_URL SUPPORT_URL BUG_REPORT_URL
OS_RELEASE_FIELDS = "ID ID_LIKE NAME VERSION VERSION_ID PRETTY_NAME"

export ID = "${DISTRO}"
export NAME = "${DISTRO_NAME}"
export VERSION = "${DISTRO_VERSION}${@' (%s)' % DISTRO_CODENAME if 'DISTRO_CODENAME' in d else ''}"
export VERSION_ID = "${DISTRO_VERSION}"
export PRETTY_NAME = "${DISTRO_NAME} ${VERSION}"

export BUILD_ID ?= "${DATETIME}"
export ID_LIKE
export ANSI_COLOR
export CPE_NAME
export HOME_URL
export SUPPORT_URL
export BUG_REPORT_URL

do_compile () {
    for field in ${OS_RELEASE_FIELDS}; do
        if eval "test -n \"\$$field\""; then
            eval "printf \"%s=%s\n\" \"\$field\" \"\$$field\""
        fi
    done >os-release
}
do_compile[vardeps] += "${OS_RELEASE_FIELDS}"

do_install () {
    install -d ${D}${sysconfdir}
    install -m 0644 os-release ${D}${sysconfdir}/
}
