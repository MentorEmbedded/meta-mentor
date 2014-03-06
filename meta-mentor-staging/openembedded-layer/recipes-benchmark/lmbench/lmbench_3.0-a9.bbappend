
LICENSE = "GPL-2.0 & GPL-2.0-with-lmbench-exception"
LIC_FILES_CHKSUM = "\
	file://COPYING;md5=8ca43cbc842c2336e835926c2166c28b \
	file://COPYING-2;md5=8e9aee2ccc75d61d107e43794a25cdf9 \
"

# If the machine installs a config file, install it to the appropriate place
do_install_append () {
    if [ -f ${WORKDIR}/CONFIG.${MACHINE} ]; then
        install -D 0644 ${WORKDIR}/CONFIG.${MACHINE} \
                        ${D}/${datadir}/lmbench/scripts/CONFIG.${MACHINE}
    fi
}
