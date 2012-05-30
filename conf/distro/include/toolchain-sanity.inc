# Work around bug in some versions regarding unaligned access
TARGET_CC_ARCH_append_arm = " -mno-unaligned-access"
TARGET_CC_KERNEL_ARCH_append_arm = " -mno-unaligned-access"

def toolchain_sanity_flags(d):
    flags = d.getVar('DEBUG_FLAGS_pn-external-csl-toolchain', True)
    if flags is None:
        flags = d.getVar('DEBUG_FLAGS', True)
    return flags.split()

python toolchain_kernel_fixup () {
    d = e.data
    if isinstance(e, bb.event.RecipeParsed) and oe.utils.inherits(d, 'kernel'):
        import re

        toolchain_path = d.getVar('EXTERNAL_TOOLCHAIN', True)
        if not toolchain_path:
            return

        # Work around kernel build error due to unused-but-set-variable + Werror
        version = d.getVar('CSL_VER_GCC', False)
        match = re.match('^([0-9]+\.[0-9]+)', version)
        if match:
            version = match.group(1)
            if [int(element) for element in version.split('.')] >= [4, 6]:
                d.setVar('KERNEL_CC_append', ' -Wno-error=unused-but-set-variable')
                d.setVar('CC_append', ' -Wno-error=unused-but-set-variable')
}
addhandler toolchain_kernel_fixup

python toolchain_sanity_check () {
    if not isinstance(e, bb.event.BuildStarted):
        return

    toolchain_path = e.data.getVar('EXTERNAL_TOOLCHAIN', True)
    if not toolchain_path:
        return

    d = e.data.createCopy()
    d.finalize()

    toolchain_sysroot = d.getVar('EXTERNAL_TOOLCHAIN_SYSROOT', True)
    if not os.path.exists(toolchain_sysroot):
        bb.fatal('No Sourcery toolchain installed at %s' % toolchain_path)

    if '-g0' in toolchain_sanity_flags(d):
        return

    if not os.path.exists(os.path.join(toolchain_path, 'license')):
        # Assuming use of a CodeBench Lite toolchain
        return

    lib_debugdir = bb.data.expand(os.path.join(toolchain_sysroot, 'lib', '.debug'), d)
    try:
        if os.listdir(lib_debugdir):
            return
    except OSError:
        pass

    bb.error("%s does not exist, or is empty" % lib_debugdir)
    bb.error('You need to install the debug info add-on via Sourcery CodeBench.')
    bb.fatal('Please refer to the trouble-shooting section of the Mentor Embedded Linux Users Manual')
}
addhandler toolchain_sanity_check
