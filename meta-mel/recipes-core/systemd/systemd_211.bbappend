FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

SRC_URI += "file://0001-systemd-disable-xml-file-stuff-and-introspection.patch \
            file://remove-links.patch \
            file://legacy-conf.patch \
            file://monotonic-timestamp.patch \
            file://fix-systemd-log-level.patch \
            file://11-sd-cards-auto-mount.rules \
            "
