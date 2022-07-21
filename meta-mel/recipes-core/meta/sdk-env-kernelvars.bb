# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SUMMARY = "Add the KERNEL_ variables to the SDK environment."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Needed to get the vars defined
inherit kernel-arch

do_install () {
    install -d "${D}/environment-setup.d"
    cat <<END >"${D}/environment-setup.d/kernel.sh"
KERNEL_CC="${KERNEL_CC}"
KERNEL_LD="${KERNEL_LD}"
KERNEL_AR="${KERNEL_AR}"
END
}

FILES:${PN} += "/environment-setup.d/*"
