# This recipe doesn't inherit systemd, so that doesn't remove the startup
# script, which makes sense, but if this ships its init script
# unconditionally, it ends up depending on initscripts-functions, which
# doesn't exist in the case where sysvinit isn't in DISTRO_FEATURES.

do_install_append_mel () {
    if ${@'true' if 'sysvinit' not in DISTRO_FEATURES.split() else 'false'}; then
        rm -rf "${D}${sysconfdir}/init.d"
    fi
}
