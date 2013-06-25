PRINC := "${@int(PRINC) + 2}"

inherit python-dir pythonnative

PACKAGECONFIG ??= "python"
PACKAGECONFIG[python] = "--enable-python,--disable-python,python-native python,python-core"

FILES_python-avahi += "${PYTHON_SITEPACKAGES_DIR}/avahi_discover"
