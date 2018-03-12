FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
		file://0001-96boards-tools-resize-helper.service-fix-for-auto-re.patch \
		"
