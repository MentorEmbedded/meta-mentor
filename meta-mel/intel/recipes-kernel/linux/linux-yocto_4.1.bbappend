FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:"

# Add Mentor logo & Fix CRDA Wifi messages
SRC_URI_append_intel-corei7-64 = " \
	file://0001-Add-Mentor-logo-to-linux-kernel.patch \
	file://0001-wireless-regulatory-reduce-log-level-of-CRDA-related.patch \
	"

# Enable necessary config options for MEL
SRC_URI_append_intel-corei7-64 = " \
	file://usb.cfg \
	file://6lowpan.cfg \
	file://bluetooth.cfg \
	file://filesystem.cfg \
	file://framebuffer.cfg \
	file://wireless.cfg \
	file://kernel.cfg \
	"
