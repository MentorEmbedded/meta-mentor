
# Specify the proper Host ARCH Flags for building
CFLAGS  += "${HOST_CC_ARCH}"
LDFLAGS += "${HOST_CC_ARCH}"

RDEPENDS_${PN} += "ca-certificates \
                  "
