# nativesdk-python-html is needed for our local development, as 'repo'
# requires the 'formatter' python module.
# nativesdk-python-terminal is needed to run oe-test-scripts, as 'sh' requires
# the 'pty' python modules.
TOOLCHAIN_HOST_TASK_append_mel = "\
    nativesdk-python-html \
    nativesdk-python-terminal \
"
