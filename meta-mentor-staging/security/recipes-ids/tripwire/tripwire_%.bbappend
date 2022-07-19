# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# Use vi by default to avoid pulling in nano
RDEPENDS_REMOVE = "nano"
RDEPENDS:${PN}:remove:feature-mentor-staging = " ${RDEPENDS_REMOVE}"

do_install:append:feature-mentor-staging () {
    # When submitting upstream, modify twcfg.txt in the layer instead
    sed -i -e 's#^EDITOR[[:space:]]*=.*#EDITOR=/usr/bin/vi#' ${D}${sysconfdir}/${PN}/twcfg.txt
    if grep -q nano ${D}${sysconfdir}/${PN}/twcfg.txt; then
        bbfatal "EDITOR adjustment failed"
    fi

    # The main recipe installs the installation script to
    # /etc which isn't meant for such stuff (executables)
    # move it to a more appropriate location
    if [ -e "${D}${sysconfdir}/tripwire/twinstall.sh" ]; then
        rm -f "${D}${sysconfdir}/tripwire/twinstall.sh"
    fi
    install -d "${D}${bindir}"
    install -m 0755 "${WORKDIR}/twinstall.sh" "${D}${bindir}/"
}
