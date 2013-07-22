# nativesdk-ca-certificates is needed in order to support oe/yocto builds with
# buildtools-tarball on old hosts, as we provide libcurl, and that needs to be
# able to find the certs, and there's no standard path or bundle path, so we
# can't rely on the host.
TOOLCHAIN_HOST_TASK += "nativesdk-ca-certificates"

# nativesdk-python-html is needed for our local development, as 'repo'
# requires the 'formatter' python module.
# nativesdk-python-terminal is needed to run oe-test-scripts, as 'sh' requires
# the 'pty' python modules.
TOOLCHAIN_HOST_TASK_append_mel = "\
    nativesdk-python-html \
    nativesdk-python-terminal \
"
