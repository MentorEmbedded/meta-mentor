PRINC := "${@int(PRINC) + 1}"

PYTHON_SITEPACKAGES_DIR = "/usr/lib/python2.7/dist-packages"

EXTRA_OECONF += "--enable-python \
                "
