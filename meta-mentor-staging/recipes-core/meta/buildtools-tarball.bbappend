# nativesdk-ca-certificates is needed in order to support oe/yocto builds with
# buildtools-tarball on old hosts, as we provide libcurl, and that needs to be
# able to find the certs, and there's no standard path or bundle path, so we
# can't rely on the host.
TOOLCHAIN_HOST_TASK += "nativesdk-ca-certificates"

# We need the perl tools in the buildtools tarball to be able to support
# bitbake's gitsm:// fetcher, as git-submodule ends up in that package.
TOOLCHAIN_HOST_TASK += "nativesdk-git-perltools"
