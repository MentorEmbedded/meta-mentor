PRINC := "${@int(PRINC) + 1}"
DEPENDS += "${@base_contains('DISTRO_FEATURES', 'x11', 'libsm libice', '', d)}"
