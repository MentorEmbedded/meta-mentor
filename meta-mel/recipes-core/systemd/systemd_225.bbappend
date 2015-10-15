FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

# Do these patches really belong in meta-mel?
SRC_URI_append_mel = "\
    file://remove-links.patch \
    file://legacy-conf.patch \
    file://fix-systemd-log-level.patch \
    file://0001-systemd-udevd-propagate-mounts-umounts-services-to-s.patch \
"

PACKAGECONFIG[defaultval] .= "${@' sysvcompat' if 'mel' in OVERRIDES.split(':') else ''}"

EXTRA_OECONF := "${@oe_filter_out('--with-sysvrcnd=${sysconfdir}' if 'mel' in OVERRIDES.split(':') else '', EXTRA_OECONF, d)}"
PACKAGECONFIG[sysvcompat] = "--with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"

RRECOMMENDS_udev += "udev-extraconf"
