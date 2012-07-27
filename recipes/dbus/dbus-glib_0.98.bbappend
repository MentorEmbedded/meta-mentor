PRINC := "${@int(PRINC) + 1}"
PACKAGES := "${@oe_filter_out('${PN}-tests', '${PACKAGES}', d)}"
PACKAGES += "${@base_contains('PACKAGECONFIG', 'tests', '${PN}-tests-dbg ${PN}-tests', '', d)}"
