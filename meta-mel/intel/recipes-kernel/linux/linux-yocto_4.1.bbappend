FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:"

# Add Mentor logo
SRC_URI_append_intel-corei7-64 = " \
	file://0001-Add-Mentor-logo-to-linux-kernel.patch"

# Enable necessary config options for MEL
SRC_URI_append_intel-corei7-64 = " \
	file://usb.cfg \
	file://6lowpan.cfg \
	file://bluetooth.cfg \
	file://filesystem.cfg \
	file://framebuffer.cfg \
	file://wireless.cfg \
	"
