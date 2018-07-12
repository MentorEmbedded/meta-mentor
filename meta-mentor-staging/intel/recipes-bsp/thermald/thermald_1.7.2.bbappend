python () {
    d.setVar('SRC_URI', d.getVar('SRC_URI', False).replace('thermal_daemon/', 'thermal_daemon'))
}
