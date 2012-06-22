PRINC := "${@int(PRINC) + 10}"

RPROVIDES_${PN}-dbg += "${TCLIBC}-dbg glibc-dbg"
RPROVIDES_${PN}-utils += "${TCLIBC}-utils glibc-utils"
RPROVIDES_${PN}-thread-db += "${TCLIBC}-thread-db glibc-thread-db"

PROVIDES := "${@oe_filter_out('linux-libc-headers', '${PROVIDES}', d)}"
PROVIDES += "${@base_conditional('PREFERRED_PROVIDER_linux-libc-headers', PN, 'linux-libc-headers', '', d)}"
DEPENDS += "${@base_conditional('PREFERRED_PROVIDER_linux-libc-headers', PN, '', 'linux-libc-headers', d)}"

do_install_append () {
    ${@base_conditional('PREFERRED_PROVIDER_linux-libc-headers', PN, '', 'rm -r ${D}${includedir}/linux ${D}${includedir}/asm*', d)}
}
