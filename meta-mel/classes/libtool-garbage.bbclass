# Backfill for existing distros
DISTRO_FEATURES_BACKFILL_append = " libtool-garbage"

# Drop for packaged bits only, not what ends up in our internal sysroots
PACKAGEBUILDPKGD_append = "${@bb.utils.contains('DISTRO_FEATURES', 'libtool-garbage', '', ' drop_libtool_garbage', d)}"

drop_libtool_garbage () {
    find "${PKGD}" -name "*.la" -exec rm "{}" \;
}
