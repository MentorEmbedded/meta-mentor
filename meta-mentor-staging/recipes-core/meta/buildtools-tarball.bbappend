# nativesdk-ca-certificates is needed in order to support oe/yocto builds with
# buildtools-tarball on old hosts, as we provide libcurl, and that needs to be
# able to find the certs, and there's no standard path or bundle path, so we
# can't rely on the host.
TOOLCHAIN_HOST_TASK += "nativesdk-ca-certificates"

# nativesdk-git-perltools is needed for git-submodule, which is needed to
# support bitbake's gitsm:// fetcher
TOOLCHAIN_HOST_TASK += "nativesdk-git-perltools"

# as with oe itself, we'll rely on the host perl. this is a hack, obviously,
# but I don't want to alter the nativesdk-git-perltools rdepends to be
# inaccurate, and there's no clean way to uninstall nativesdk-perl without
# also uninstalling nativesdk-git-perltools
SDK_POSTPROCESS_COMMAND_append_pn-buildtools-tarball = "kill_perl;"
do_populate_sdk[vardeps] += "SDK_POSTPROCESS_COMMAND"

kill_perl () {
    rm ${SDK_OUTPUT}${SDKPATHNATIVE}${bindir_nativesdk}/perl
    rm -r ${SDK_OUTPUT}${SDKPATHNATIVE}${libdir_nativesdk}/perl
}

create_sdk_files_append () {
    echo 'export GIT_SSL_CAINFO="${SDKPATHNATIVE}${sysconfdir}/ssl/certs/ca-certificates.crt"' >>$script
}
