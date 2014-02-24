DEPENDS += "${@base_contains('DISTRO_FEATURES', 'x11', 'xkeyboard-config', '', d)}"

EXTRA_OECONF += "${@base_contains('DISTRO_FEATURES', 'x11', '', '--disable-x11', d)}"
