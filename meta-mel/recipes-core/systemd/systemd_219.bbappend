FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/${PN}:"

SRC_URI += "file://remove-links.patch \
            file://legacy-conf.patch \
            file://fix-systemd-log-level.patch \
            file://11-sd-cards-auto-mount.rules \
            file://0001-systemd-udevd-propagate-mounts-umounts-services-to-s.patch \
            "
