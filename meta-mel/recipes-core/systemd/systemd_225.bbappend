FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

# Do these patches really belong in meta-mel?
SRC_URI_append_mel = "\
    file://legacy-conf.patch \
    file://fix-systemd-log-level.patch \
"

MEL_PACKAGECONFIG = ""
MEL_PACKAGECONFIG_mel = " sysvcompat"
PACKAGECONFIG[defaultval] .= "${MEL_PACKAGECONFIG}"

PACKAGECONFIG[sysvcompat] = "--with-sysvinit-path=${sysconfdir}/init.d --with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"
