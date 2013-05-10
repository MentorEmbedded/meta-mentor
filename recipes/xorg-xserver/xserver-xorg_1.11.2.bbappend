PRINC := "${@int(PRINC) + 5}"

LIB_DEPS := "${@oe_filter_out('virtual/libgl', '${LIB_DEPS}', d)}"

RDEPENDS_${PN} += "  \
    xserver-xorg-extension-dbe \
    xserver-xorg-extension-extmod \
"

PACKAGECONFIG ??= "udev"
