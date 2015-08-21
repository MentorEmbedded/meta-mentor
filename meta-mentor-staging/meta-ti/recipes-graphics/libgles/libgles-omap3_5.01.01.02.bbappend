do_install_append () {
    # Correct ownership on prebuilt binaries copied into ${D}
    chown -R root:root "${D}"
}
