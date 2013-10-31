PACKAGECONFIG[gconf] = "--enable-gconf,--disable-gconf,gconf,"

# Currently this is in PACKAGES_DYNAMIC via a regex, not PACKAGES, so bitbake
# is unaware of its defined RDEPENDS. Add it explicitly to work around this.
PACKAGES += "pulseaudio-module-console-kit"

do_install_append() {
        sed -i 's/; resample-method.*/resample-method \= speex-fixed-3/' ${D}/etc/pulse/daemon.conf
}
