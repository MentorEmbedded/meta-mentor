pkg_postinst_${PN}_append () {
    # Work around pseudo bug (see pseudo.log. when this isn't done, the
    # symlinks created by update-ca-certificates end up with inode and symlink
    # mismatches, resulting in host user contamination.
    chown -h root:root "$D${sysconfdir}/ssl/certs/"*.pem
}
