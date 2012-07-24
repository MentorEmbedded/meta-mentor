PRINC := "${@int(PRINC) + 1}"
RDEPENDS_${PN} = "distcc ${@base_contains('DISTRO_FEATURES', 'x11', 'dbus-x11 oprofileui-server', '', d)} task-core-nfs-server rsync bash"
