# If the machine installs a config file, install it to the appropriate place
do_install_append () {
    if [ -f ${WORKDIR}/CONFIG.${MACHINE} ]; then
        install -D 0644 ${WORKDIR}/CONFIG.${MACHINE} \
                        ${D}/${datadir}/lmbench/scripts/CONFIG.${MACHINE}
    fi
}
