# Support config fragments, and configure for lttng
inherit cml1-config kernel-config-lttng


LOCKDOWN_SRCREV = "4b66366af2d77de68f4bd6548d07421e13d3df05"
PV = "3.8.13-mel-fsl-qoriq-1"
SRC_URI_remove = "git://git.freescale.com/ppc/sdk/linux.git"
SRC_URI =+ "https://github.com/MentorEmbedded/linux-mel/archive/fsl-sdk-v1.4.tar.gz;downloadfilename=linux-mel-fsl-sdk-v1.4.tar.gz"
SRC_URI[md5sum] = "1452b30c99629d385476105fe5169e4a"
SRC_URI[sha256sum] = "a60e2d3450bee6f00da0535683f573737e02114531522ecbdeb3bbe777e154e5"
S = "${WORKDIR}/linux-mel-fsl-sdk-v1.4"


DEFCONFIG = "${KERNEL_DEFCONFIG}"

python () {
    d.setVar("do_configure", 'kernel_do_configure')

    if d.getVar('SRCREV', True) != d.getVar('LOCKDOWN_SRCREV', True):
        bb.fatal("linux-qoriq-sdk SRCREV has been updated, the bbappend in meta-mentor needs updating to match.")
}
