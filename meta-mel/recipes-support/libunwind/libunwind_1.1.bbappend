FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += "\
    file://Fix-test-case-link-failure-on-PowerPC-systems-with-Altivec.patch \
"
