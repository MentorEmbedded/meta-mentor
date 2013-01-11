PR .= ".1"
FILESEXTRAPATHS_prepend := "${THISDIR}/libpcap:"
SRC_URI += "file://fix-canusb-argument.patch"
PACKAGECONFIG[canusb] = "--enable-canusb,--disable-canusb,libusb1"
