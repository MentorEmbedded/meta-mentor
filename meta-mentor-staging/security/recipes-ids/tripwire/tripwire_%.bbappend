# Use vi by default to avoid pulling in nano
RDEPENDS_REMOVE = "nano"
RDEPENDS_${PN}_remove = "${RDEPENDS_REMOVE}"

do_install_append () {
    # When submitting upstream, modify twcfg.txt in the layer instead
    sed -i -e 's#^EDITOR=#EDITOR=/usr/bin/vi#' ${D}${sysconfdir}/${PN}/twcfg.txt
    if grep -q nano ${D}${sysconfdir}/${PN}/twcfg.txt; then
        bbfatal "EDITOR adjustment failed"
    fi
}
