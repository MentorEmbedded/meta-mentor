PACKAGECONFIG[gconf] = "--enable-gconf,--disable-gconf,gconf,"

# Currently this is in PACKAGES_DYNAMIC via a regex, not PACKAGES, so bitbake
# is unaware of its defined RDEPENDS. Add it explicitly to work around this.
PACKAGES += "pulseaudio-module-console-kit"
