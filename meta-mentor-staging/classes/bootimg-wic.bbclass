python () {
    if oe.utils.inherits(d, 'bootimg'):
        bb.build.addtask('do_image_wic', '', 'do_bootimg', d)
}
