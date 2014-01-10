# nativesdk-ca-certificates is needed in order to support oe/yocto builds with
# buildtools-tarball on old hosts, as we provide libcurl, and that needs to be
# able to find the certs, and there's no standard path or bundle path, so we
# can't rely on the host.
TOOLCHAIN_HOST_TASK += "nativesdk-ca-certificates"
