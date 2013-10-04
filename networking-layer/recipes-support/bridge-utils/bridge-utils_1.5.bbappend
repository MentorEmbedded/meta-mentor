pkg_postinst_${PN} () {
}

pkg_prerm_${PN} () {
}

inherit update-alternatives

ALTERNATIVE_PRIORITY = "75"
ALTERNATIVE_${PN} = "brctl"
ALTERNATIVE_LINK_NAME[brctl] = "${sbindir}/brctl"
