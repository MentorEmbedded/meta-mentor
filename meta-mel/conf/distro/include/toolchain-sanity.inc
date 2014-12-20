# Work around bug in some versions regarding unaligned access
TARGET_CC_ARCH_append_arm = " -mno-unaligned-access"
TARGET_CC_KERNEL_ARCH_append_arm = " -mno-unaligned-access"

python toolchain_kernel_fixup () {
    d = e.data
    if isinstance(e, bb.event.RecipeParsed) and oe.utils.inherits(d, 'kernel'):
        import re
        if d.getVar('TCMODE', True) == 'default':
            return

        toolchain_path = d.getVar('EXTERNAL_TOOLCHAIN', True)
        if not toolchain_path:
            return

        # Work around kernel build error due to unused-but-set-variable + Werror
        version = d.getVar('GCC_VERSION', False)
        match = re.match('^([0-9]+\.[0-9]+)', version)
        if match:
            version = match.group(1)
            num_version = [int(element) for element in version.split('.')]
            if num_version >= [4, 6]:
                d.appendVar('TARGET_CC_ARCH', ' -Wno-error=unused-but-set-variable')
                d.appendVar('TARGET_CC_KERNEL_ARCH', ' -Wno-error=unused-but-set-variable')
            if num_version >= [4, 7]:
                d.appendVar('TARGET_CC_ARCH', ' -Wno-error=maybe-uninitialized')
                d.appendVar('TARGET_CC_KERNEL_ARCH', ' -Wno-error=maybe-uninitialized')
}
addhandler toolchain_kernel_fixup

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
        if sourcery_version && sourcery_version != toolchain_required_version:
            bb.fatal('Found toolchain version `%s`, expected `%s`. Please install the supported toolchain.' % ('-'.join(sourcery_version), '-'.join(toolchain_required_version)))
}
addhandler toolchain_sanity_check
