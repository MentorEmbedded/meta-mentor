
do_install_append() {
    # Install agent utility for pairing devices
    install -m 777 ${S}/test/agent ${D}/usr/bin/bluetooth-agent
}

