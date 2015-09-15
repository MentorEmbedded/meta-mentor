do_configure_prepend () {
    # xml-config takes --version, but we want --modversion for pkg-config
    sed -i -e 's/--version/--modversion/' setupinfo.py
}
