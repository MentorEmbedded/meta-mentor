FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${PN}:"

SRC_URI_append_feature-mentor-staging = " file://0001-Use-an-array-for-efi-ld-to-allow-for-ld-arguments.patch"

LDFLAGS_remove_feature-mentor-staging := "${@ " ".join(d.getVar('LD').split()[1:])} "
EXTRA_OEMESON_append_feature-mentor-staging = ' "-Defi-ld=${@meson_array("LD", d)}"'
