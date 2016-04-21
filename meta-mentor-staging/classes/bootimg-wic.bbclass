python () {
    if 'do_image_wic' in d and 'do_bootimg' in d:
        bb.build.addtask('do_image_wic', '', 'do_bootimg', d)
}
