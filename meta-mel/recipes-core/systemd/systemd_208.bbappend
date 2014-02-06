FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

SRC_URI += "file://0001-systemd-disable-xml-file-stuff-and-introspection.patch \
            file://remove-links.patch \
            file://legacy-conf.patch \
            file://monotonic-timestamp.patch \
            file://fix-systemd-log-level.patch \
            file://11-sd-cards-auto-mount.rules \
            "

PACKAGECONFIG[defaultval] .= "${@' sysvcompat' if 'mel' in OVERRIDES.split(':') else ''}"

EXTRA_OECONF := "${@oe_filter_out('--with-sysvrcnd=${sysconfdir}' if 'mel' in OVERRIDES.split(':') else '', EXTRA_OECONF, d)}"
PACKAGECONFIG[sysvcompat] = "--with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"
