python toolchain_sanity_check () {
    if not isinstance(e, bb.event.BuildStarted):
        return

    if e.data.getVar('TCMODE', True) == 'default':
        return

    # Make sure the toolchain actually exists
    toolchain_path = e.data.getVar('EXTERNAL_TOOLCHAIN', True)
    if not toolchain_path:
        return

    d = e.data.createCopy()
    d.finalize()

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
        sourcery_version = version(d.getVar('SOURCERY_VERSION', True))
        if sourcery_version and sourcery_version != toolchain_required_version:
            bb.fatal('Found toolchain version `%s`, expected `%s`. Please install the supported toolchain.' % ('-'.join(sourcery_version), '-'.join(toolchain_required_version)))
}
addhandler toolchain_sanity_check
