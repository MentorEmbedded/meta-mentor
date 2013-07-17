# nativesdk-python-html is needed for local development, as 'repo' requires
# the 'formatter' python module.
# nativesdk-python-terminal is needed to run oe-test-scripts, as 'sh' requires
# the 'pty' python modules.
TOOLCHAIN_HOST_TASK += "\
    nativesdk-ca-certificates \
    nativesdk-python-html \
    nativesdk-python-terminal \
"
