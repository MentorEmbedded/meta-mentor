PR .= ".1"
FILESEXTRAPATHS_prepend := "${THISDIR}/quota:"
SRC_URI += "file://config-tcpwrappers.patch"
PACKAGECONFIG[tcpwrappers] = "--with-tcpwrappers,--without-tcpwrappers,tcp-wrappers"
