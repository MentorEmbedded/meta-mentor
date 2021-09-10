bindir_progs_remove = "nice"

do_install_append() {
    mv ${D}${bindir}/nice ${D}${bindir}/nice.${BPN}
}

ALTERNATIVE_${PN} += "nice"
ALTERNATIVE_${PN}-doc += "nice.1"

ALTERNATIVE_LINK_NAME[nice] = "${base_bindir}/nice"
ALTERNATIVE_TARGET[nice] = "${bindir}/nice.${BPN}"
ALTERNATIVE_LINK_NAME[nice.1] = "${mandir}/man1/nice.1"
