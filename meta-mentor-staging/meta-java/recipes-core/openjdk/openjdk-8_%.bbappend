FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${PN}:"

SRC_URI_append_feature-mentor-staging = " file://0001-PR3597-Potential-bogus-Wformat-overflow-warning-with.patch"

