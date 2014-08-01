python sstate_config_handler () {
    d = e.data

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

INHERIT += "sstate-mirror-sites"

# We know RHEL 6 is the oldest distro we support, and that binaries built
# there will run on any other host we support
SSTATE_MIRROR_DISTROS = "RedHatEnterprise-6"

def lsb_distro_adjust(distro_id, ver):
    """This hook ensures that RHEL server, RHEL client, and CentOS all return
    'RedHatEnterprise' for distro, and just the major part for the version, as
    we know minor versions for these distros are compatible, and these distros
    are compatible with one another."""

    if distro_id in ('RedHatEnterpriseClient', 'RedHatEnterpriseServer',
                     'CentOS'):
        distro_id = 'RedHatEnterprise'

        try:
            major_ver, _ = ver.split('.', 1)
        except ValueError:
            pass
        else:
            ver = major_ver
    return distro_id, ver

LSB_DISTRO_ADJUST = "lsb_distro_adjust"
