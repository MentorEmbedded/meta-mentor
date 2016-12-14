FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "\
    file://correct-python3-lib-pathes-for-multilib-support.patch \
    file://0001-site.py-obey-sys.lib-for-sitepackages.patch \
"
