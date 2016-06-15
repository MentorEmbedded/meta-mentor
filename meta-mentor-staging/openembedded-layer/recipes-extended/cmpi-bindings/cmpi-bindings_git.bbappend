FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://Find-PythonInterp-before-PythonLibs.patch"

do_configure[exports] += "PYTHON_EXECUTABLE"
