# nativesdk-python-html is needed for local development, as 'repo' requires
# the 'formatter' python module.
TOOLCHAIN_HOST_TASK += "\
    nativesdk-ca-certificates \
    nativesdk-python-html \
"
