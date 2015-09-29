FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

# Do these patches really belong in meta-mel?
SRC_URI_append_mel = "\
    file://remove-links.patch \
    file://legacy-conf.patch \
    file://fix-systemd-log-level.patch \
    file://0001-systemd-udevd-propagate-mounts-umounts-services-to-s.patch \
"

MEL_PACKAGECONFIG = ""
MEL_PACKAGECONFIG_mel = " sysvcompat"
PACKAGECONFIG[defaultval] .= "${MEL_PACKAGECONFIG}"

PACKAGECONFIG[sysvcompat] = "--with-sysvinit-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"
