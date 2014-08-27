# FIXME: Putting host binaries in a target package is not ideal, it should be
# a nativesdk recipe. Hopefully we can get away with having a nativesdk recipe
# depend on a target recipe, otherwise we'd have to set SRC_URI rather than
# pulling from STAGING_KERNEL_DIR.

inherit linux-kernel-base kernel-arch

PN .= "-${@legitimize_package_name('${BUILD_ARCH}')}"
KERNEL_VERSION = "${@get_kernelversion('${STAGING_KERNEL_DIR}')}"
PKGV = "${KERNEL_VERSION}"
SUMMARY = "Host-built binaries from kernel/scripts/ for out-of-tree kernel module builds"
DEPENDS += "virtual/kernel"
PROVIDES += "kernel-host-dev"
RPROVIDES_${PN} += "kernel-host-dev"
SRC_URI = ""
KERNEL_SRC_PATH ?= "/usr/src/kernel"

# Pulling GPLv2 binaries from the staged kernel source
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

# Needed so we have a static libncurses for kconfig
DEPENDS += "ncurses-native"

do_configure () {
    cd "${STAGING_KERNEL_DIR}"
    find . | cpio -pdlu "${B}"
    cd - >/dev/null
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    oe_runmake clean _mrproper_scripts
    find scripts | sort >cleanfiles
}

# Build the host binaries from scripts/ statically
do_compile () {
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    make V=1 CC="${KERNEL_CC}" LD="${KERNEL_LD}" AR="${KERNEL_AR}" HOSTLDFLAGS="${BUILD_LDFLAGS} -static" HOSTCFLAGS="${BUILD_CFLAGS} -static" scripts
    find scripts | sort >builtfiles
}

# Install the host binaries from scripts/
do_install () {
    comm -13 cleanfiles builtfiles | cpio -pdlu "${D}${KERNEL_SRC_PATH}"
}

sysroot_stage_all () {
    :
}

PACKAGES = "${PN}"
FILES_${PN} = "${KERNEL_SRC_PATH}/scripts"

# Machine specific because the kernel in question is machine specific
PACKAGE_ARCH = "${MACHINE_ARCH}"

# Allow shipping the host binaries from $kerneldir/scripts, gross hack
ERROR_QA_remove = "arch"
INHIBIT_PACKAGE_STRIP = "1"
