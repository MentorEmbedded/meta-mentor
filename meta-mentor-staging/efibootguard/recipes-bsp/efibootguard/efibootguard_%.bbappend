FILESEXTRAPATHS_prepend_feature-mentor-staging := "${THISDIR}/${BPN}:"

SRC_URI_append_feature-mentor-staging = " file://0001-ebgpart-fix-conflict-with-__unused-in-system-headers.patch"
