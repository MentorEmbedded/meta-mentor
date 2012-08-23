PRINC := "${@int(PRINC) + 1}"
RPROVIDES_${PN}-mtrace = "glibc${PKGSUFFIX}-mtrace libc${PKGSUFFIX}-mtrace"
