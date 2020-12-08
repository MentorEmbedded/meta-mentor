FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${PN}:"

SRC_URI_append_feature-mentor-staging = "\
    file://0001-PR3597-Potential-bogus-Wformat-overflow-warning-with.patch \
    file://0002-8184309-PR3596-Build-warnings-from-GCC-7.1-on-Fedora.patch \
"
