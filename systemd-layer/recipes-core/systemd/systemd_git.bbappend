PR .= ".1"

DEPENDS += "python"

# need to export these variables for python-config to work
export BUILD_SYS
export HOST_SYS
export STAGING_INCDIR
export STAGING_LIBDIR

inherit pythonnative python-dir

EXTRA_OECONF += "--with-python"

PACKAGES =+ "python-${PN}-journal"

FILES_python-${PN}-journal = "${PYTHON_SITEPACKAGES_DIR}/systemd/*.py* ${PYTHON_SITEPACKAGES_DIR}/systemd/*.so"
RDEPENDS_python-${PN}-journal = "python-core"

FILES_${PN}-dbg += "${PYTHON_SITEPACKAGES_DIR}/systemd/.debug/"
FILES_${PN}-dev += "${PYTHON_SITEPACKAGES_DIR}/systemd/*.la"
