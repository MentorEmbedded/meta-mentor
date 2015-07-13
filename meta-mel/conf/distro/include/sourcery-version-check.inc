python sourcery_version_check () {
    if d.getVar('TCMODE', True) == 'default':
        return

    sourcery_version = d.getVar('SOURCERY_VERSION', True)
    if not sourcery_version or sourcery_version == 'UNKNOWN':
        return

    def version(str):
        if str is None:
            return []

        elements = str.split('-')
        if len(elements) > 1:
            elements.pop()
        return elements

    # Check for a specified required toolchain version for releases
    toolchain_required_version = version(d.getVar('SOURCERY_VERSION_REQUIRED', True))
    if toolchain_required_version:
        sourcery_version = version(sourcery_version)
        if sourcery_version != toolchain_required_version:
            bb.fatal('Found toolchain version `%s`, expected `%s`. Please install the supported toolchain.' % ('-'.join(sourcery_version), '-'.join(toolchain_required_version)))
}
# We run this at build start to ensure that bitbake -e still works
sourcery_version_check[eventmask] = "bb.event.BuildStarted"
addhandler sourcery_version_check
