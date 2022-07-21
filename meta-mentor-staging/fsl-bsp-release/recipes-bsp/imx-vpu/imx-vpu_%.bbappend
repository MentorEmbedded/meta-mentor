# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

do_install:append:feature-mentor-staging () {
    if [ "${libdir}" != "/usr/lib" ]; then
        install -d "$(dirname "${D}${libdir}")"
        mv "${D}/usr/lib" "${D}${libdir}"
    fi
    if [ "${includedir}" != "/usr/include" ]; then
        install -d "$(dirname "${D}${includedir}")"
        mv "${D}/usr/include" "${D}${includedir}"
    fi
    rmdir --ignore-fail-on-non-empty "${D}/usr"
}
