python () {
    if oe.utils.inherits(d, 'bootimg') and d.getVar('do_image_wic', False):
        bb.build.addtask('do_image_wic', '', 'do_bootimg', d)
}
