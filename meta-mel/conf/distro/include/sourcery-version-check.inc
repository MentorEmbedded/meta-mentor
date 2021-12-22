# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

python sourcery_version_check () {
    if d.getVar('TCMODE', True) == 'default':
        return

    sourcery_version = d.getVar('SOURCERY_VERSION', True)
    if not sourcery_version or sourcery_version == 'UNKNOWN':
        return

    def version(s):
        if s is None:
            return []
        ver = s.split('-', 1)[0].split('.')
        if len(ver) > 2:
            ver = ver[:2]
        return ver

    # Check for a specified required toolchain version for releases
    toolchain_required_version = d.getVar('SOURCERY_VERSION_REQUIRED')
    if toolchain_required_version:
        if version(sourcery_version) != version(toolchain_required_version):
            bb.fatal('Found toolchain version `%s`, expected `%s`. Please install the supported toolchain.' % (sourcery_version, toolchain_required_version))
}
# We run this at build start to ensure that bitbake -e still works
sourcery_version_check[eventmask] = "bb.event.BuildStarted"
addhandler sourcery_version_check
