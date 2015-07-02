# Support config fragments, and configure for lttng
inherit kernel cml1-config kernel-config-lttng

python () {
    d.setVar("do_configure", 'kernel_do_configure')
}

KERNEL_SRC_URI ?= "https://s3.amazonaws.com/portal.mentor.com/sources/MEL-2014.12/linux-ls1-3.12.tar.xz"
SRC_URI = "${KERNEL_SRC_URI} \
	   file://defconfig"

# Enable systemd config
SRC_URI += "${@base_contains('DISTRO_FEATURES', 'systemd', ' file://systemd.cfg', '', d)}"

# Enable kgdb & config_proc config
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://kgdb.cfg \
            file://configs.cfg \
            file://autofs.cfg \
            file://filesystems.cfg \
            file://unionfs-2.6_for_3.12.26.patch \
            file://6lowpan.cfg \
            "

S = "${WORKDIR}/${BP}"

SRC_URI[md5sum] = "89659d78aa2e51a4998037b307095f5d"
SRC_URI[sha256sum] = "52572a1ab768496a629c7ca2fd1fa3a04e030583e285f2733eee9ddd88a38c7e"
