FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:"
FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which("${BBPATH}", 'files/kgdb.cfg') or '')}"

# Add Mentor logo & Fix CRDA Wifi messages
SRC_URI_append_intel-corei7-64 = " \
	file://0001-Add-Mentor-logo-to-linux-kernel.patch \
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
	file://kgdb.cfg \
	"

# Add Shallow support for mirror tarballs
BB_GIT_SHALLOW_machine = "v4.4"
BB_GIT_SHALLOW_meta = ""
