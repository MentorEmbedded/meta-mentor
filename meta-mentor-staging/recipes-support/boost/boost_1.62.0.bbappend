FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://0001-Apply-boost-1.62.0-no-forced-flags.patch.patch \
    file://0003-Don-t-set-up-arch-instruction-set-flags-we-do-that-o.patch \
    file://0002-Don-t-set-up-m32-m64-we-do-that-ourselves.patch \
"
BJAM_OPTS_append_linux-gnux32 = " abi=x32 address-model=64"
