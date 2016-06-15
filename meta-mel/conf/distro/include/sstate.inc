# For compatibility
SSTATE_MIRROR_SITES ?= ""
SSTATE_MIRRORS += "${@''.join(r'file://.* %s/PATH;downloadfilename=PATH \n' % u for u in '${SSTATE_MIRROR_SITES}'.split())}"

# Handle sstate checksum issues
python sstate_config_handler () {
    # Ensure the path to the mel install doesn't affect checksums
    d.appendVar('BB_HASHBASE_WHITELIST', ' MELDIR')

    # These vars shouldn't change except for when BUILD_ARCH does, and that's
    # already captured via the sstate archive filename. Excluding them should
    # let us reuse target sstates even if the BUILD_ARCH of the natives
    # changes (e.g. reuse target between 32 and 64 bit build hosts).
    d.appendVar("BB_HASHBASE_WHITELIST", " SITEINFO_ENDIANNESS SITEINFO_BITS SIZEOF_POINTER")
}
sstate_config_handler[eventmask] = "bb.event.ConfigParsed"
addhandler sstate_config_handler
