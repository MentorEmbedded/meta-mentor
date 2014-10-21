FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://add-polkit-configure-argument.patch"
PACKAGECONFIG[polkit] = "--with-polkit,--without-polkit,polkit,"

# For glib-gettextize
DEPENDS += "glib-2.0-native"

SRC_URI += " \
    file://02-consolekit.conf \
"

do_install_append () {
    rm -rf ${D}${localstatedir}/log ${D}${localstatedir}/run ${D}${localstatedir}/volatile
    install -D -m 0644 ${WORKDIR}/02-consolekit.conf ${D}${sysconfdir}/tmpfiles.d/02-consolekit.conf
    ${@bb.utils.contains("DISTRO_FEATURES", "systemd", "sed -i '/After=/a After=systemd-tmpfiles-setup.service' ${D}${base_libdir}/systemd/system/console-kit-log-system-start.service", "", d)}
}
