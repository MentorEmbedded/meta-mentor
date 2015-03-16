require recipes-extended/xen/xen.inc

SRC_URI = " \
    http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz \
    file://xen-x86-Fix-up-rules-when-forcing-mno-sse.patch \
    "

SRC_URI[md5sum] = "9bac43d2419d05a647064d9253bb03fa"
SRC_URI[sha256sum] = "5bdb40e2b28d2eeb541bd71a9777f40cbe2ae444b987521d33f099541a006f3b"

S = "${WORKDIR}/xen-${PV}"

# Xen suffixes the libexecdir within its configure scripts, prevent the nested xen/xen/
libexecdir = "${libdir}"

# These options override detected values from the build.
EXTRA_OECONF_append += " \
    --with-initddir=${INIT_D_DIR} \
    --with-sysconfig-leaf-dir=default \
    --with-system-qemu=/usr/bin/qemu-system-i386 \
    --disable-qemu-traditional \
    "

EXTRA_OEMAKE += "STDVGA_ROM=${STAGING_DIR_HOST}/usr/share/firmware/vgabios-0.7a.bin"
EXTRA_OEMAKE += "CIRRUSVGA_ROM=${STAGING_DIR_HOST}/usr/share/firmware/vgabios-0.7a.cirrus.bin"
EXTRA_OEMAKE += "SEABIOS_ROM=${STAGING_DIR_HOST}/usr/share/firmware/bios.bin"
EXTRA_OEMAKE += "ETHERBOOT_ROMS=${STAGING_DIR_HOST}/usr/share/firmware/rtl8139.rom"
#EXTRA_OEMAKE += "XENGFX_ROM=${STAGING_DIR_HOST}/usr/share/firmware/vgabios.bin"

do_configure_prepend() {
    # fixup AS/CC/CCP/etc variable within StdGNU.mk
    for i in AS LD CC CPP AR RANLIB NM STRIP OBJCOPY OBJDUMP; do
        sed -i "s/^\($i\s\s*\).*=/\1?=/" ${S}/config/StdGNU.mk
    done
    # fixup environment passing in some makefiles
    sed -i 's#\(\w*\)=\(\$.\w*.\)#\1="\2"#' ${S}/tools/firmware/Makefile

    # libsystemd-daemon -> libsystemd for newer systemd versions
    sed -i 's#libsystemd-daemon#libsystemd#' ${S}/tools/configure
}

do_install_append() {
    # fixup default path to qemu-system-i386
    sed -i 's#\(test -z "$QEMU_XEN" && QEMU_XEN=\).*$#\1"/usr/bin/qemu-system-i386"#' ${D}/etc/init.d/xencommons

    if [ -e ${D}${systemd_unitdir}/system/xen-qemu-dom0-disk-backend.service ]; then
        sed -i 's#ExecStart=.*qemu-system-i386\(.*\)$#ExecStart=/usr/bin/qemu-system-i386\1#' \
            ${D}${systemd_unitdir}/system/xen-qemu-dom0-disk-backend.service
    fi
}
