FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "\
    file://0001-ebgpart-fix-conflict-with-__unused-in-system-headers.patch \
    file://0003-strn-cpy-cat-fixes-for-gcc8.patch \
"
