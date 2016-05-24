python () {
    d.setVar('LIC_FILES_CHKSUM', d.getVar('LIC_FILES_CHKSUM', False).replace('files://', 'file://'))
}
