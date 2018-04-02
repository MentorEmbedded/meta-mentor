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
