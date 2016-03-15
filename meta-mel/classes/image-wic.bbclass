inherit image_types_wic

fakeroot python do_wic_image () {
       from oe.image import create_image
       d.setVar('IMAGE_FSTYPES', 'wic.bz2')

       # generate final image of wic
       create_image(d)
}

addtask wic_image before do_build after do_bootimg
