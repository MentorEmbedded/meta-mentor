PR .= ".1"

LDFLAGS := "${@LDFLAGS.replace('-lGAL-x11', '-lGAL')}"
