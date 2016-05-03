python () {
    if d.getVar('USING_WIC', True) and 'do_bootimg' in d:
        bb.build.addtask('do_image_wic', '', 'do_bootimg', d)
}
