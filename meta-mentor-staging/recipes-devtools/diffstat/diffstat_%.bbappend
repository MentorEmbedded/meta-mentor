python () {
    src = d.getVar('SRC_URI', True)
    if 'ftp://invisible-island.net/' in src:
        src = src.replace('ftp://invisible-island.net/', 'ftp://ftp.invisible-island.net/')
        d.setVar('SRC_URI', src)
}
