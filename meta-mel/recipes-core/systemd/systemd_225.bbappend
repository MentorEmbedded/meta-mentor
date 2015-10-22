MEL_PACKAGECONFIG = ""
MEL_PACKAGECONFIG_mel = " sysvcompat"
PACKAGECONFIG[defaultval] .= "${MEL_PACKAGECONFIG}"
PACKAGECONFIG[sysvcompat] = "--with-sysvinit-path=${sysconfdir}/init.d --with-sysvrcnd-path=${sysconfdir},--with-sysvinit-path= --with-sysvrcnd-path=,"

SYSTEMD_LOGLEVEL ?= "info"
SYSTEMD_LOGLEVEL_mel ?= "emerg"

do_compile_append_mel () {
    printf '[Manager]\n' >loglevel.conf
    printf 'LogLevel=${SYSTEMD_LOGLEVEL}\n' >>loglevel.conf
}

do_install_append_mel () {
    install -d "${D}${nonarch_libdir}/systemd/system.conf.d"
    install -m 0644 loglevel.conf "${D}${nonarch_libdir}/systemd/system.conf.d/"
}
