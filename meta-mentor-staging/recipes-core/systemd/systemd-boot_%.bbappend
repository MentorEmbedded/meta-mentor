FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Use-an-array-for-efi-ld-to-allow-for-ld-arguments.patch"

LDFLAGS_remove := "${@ " ".join(d.getVar('LD').split()[1:])} "
EXTRA_OEMESON += '"-Defi-ld=${@meson_array("LD", d)}"'
